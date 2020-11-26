import { useAccountPkh, useReady, useTezos, useWallet } from "dapp/dapp";
import { TEZOSLAND_ADDRESS } from "dapp/defaults";
import * as React from "react";
import { useEffect, useState } from "react";

import { MapStyled } from "./Map.style";
import { MapView } from "./Map.view";

export type Coordinates = {
  x: number;
  y: number;
};

export enum LandType {
  Road = "Road",
  Water = "Water",
  Land = "Land",
  District = "District",
  Plaza = "Plaza",
}

export type Token = {
  name?: string;
  description?: string;
  position: Coordinates;
  landType: LandType;
  isOwned: boolean;
  onSale: boolean;
  price: number;
  id: number;
};

export const Map = () => {
  const wallet = useWallet();
  const ready = useReady();
  const tezos = useTezos();
  const accountPkh = useAccountPkh();
  const [contract, setContract] = useState(undefined);
  const [tokens, setTokens] = useState<Token[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  
  useEffect(() => {
    (async () => {
      if (tezos) {
        const ctr = await (tezos as any).wallet.at(TEZOSLAND_ADDRESS);
        setContract(ctr);
      }
    })();
  }, [tezos]);

  useEffect(() => {
    (async () => {
      if (contract) {
        const storage = await (contract as any).storage();
        const allTokensFromStorage = storage["market"].landIds;
        console.log(allTokensFromStorage)
        if (allTokensFromStorage) {
          const tokenIds: number[] = allTokensFromStorage.map(
            (token: { c: any[] }) => token.c[0]
          );

          const tokens = await Promise.all(tokenIds.map(async (tokenId) => {
            const tokenRaw = await storage.market.lands.get(tokenId.toString());
            const token: Token = {
              name: tokenRaw.name,
              description: tokenRaw.description,
              position: {
                x: tokenRaw.position[6].c[0],
                y: tokenRaw.position[7].c[0]
              },
              landType: LandType.District,
              isOwned: tokenRaw.isOwned,
              onSale: tokenRaw.onSale,
              price: tokenRaw.price,
              id: tokenRaw.id.c[0],
            }
            return token;
          }));

          setTokens(tokens)
          setLoading(false);
        }
      }
    })();
  }, [contract, accountPkh]);

  // useOnBlock(tezos, loadStorage)

  type MapToken = { token_id: number; price: number };
  

  return (
    <MapStyled>
      {wallet ? (
        <>
          {ready ? (
            <>
              {tokens && tokens.length > 0 ? (
                <MapView existingTokens={tokens} />
              ) : (
                <div>
                  {loading ? (
                    <div>Loading lands... Please wait.</div>
                  ) : (
                    <div>No land available</div>
                  )}
                </div>
              )}
            </>
          ) : (
            <div>Please connect your wallet.</div>
          )}
        </>
      ) : (
        <div>Please install the Thanos Wallet Chrome Extension.</div>
      )}
    </MapStyled>
  );
};
