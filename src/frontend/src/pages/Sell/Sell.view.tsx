import { LandMap } from "app/App.components/LandMap/LandMap.view";
import * as React from "react";
import { useState } from "react";

import { Token } from "./Sell.controller";
// prettier-ignore
import { SellLandBottom, SellLandButton, SellLandFirstRow, SellLandLocation, SellLandOnSale, SellLandPriceInput, SellLandSecondRow, SellLandStyled, CancelSaleButton } from "./Sell.style";

type SellViewProps = {
  sellTokenCallback: ({}: any) => void;
  cancelSaleCallback: ({}: any) => void;
  myTokens: Token[];
};

export const SellView = ({ sellTokenCallback, cancelSaleCallback, myTokens }: SellViewProps) => {
  return (
    <>
      {myTokens.map((myToken) => (
        <SellLand
          key={myToken.id}
          sellTokenCallback={sellTokenCallback}
          cancelSaleCallback={cancelSaleCallback}
          myToken={myToken}
        />
      ))}
    </>
  );
};

const SellLand = ({
  sellTokenCallback,
  cancelSaleCallback,
  myToken,
}: {
  sellTokenCallback: ({}: any) => void;
  cancelSaleCallback: ({}: any) => void;
  myToken: Token;
}) => {
  const [price, setPrice] = useState<string>("");

  return (
    <SellLandStyled key={myToken.id}>
      <LandMap x={myToken.position.x} y={myToken.position.y} />

      <SellLandBottom>
        <SellLandFirstRow>
          <SellLandLocation>
            <svg>
              <use xlinkHref="/icons/sprites.svg#location" />
            </svg>
            <div>{`${myToken.position.x}, ${myToken.position.y}`}</div>
          </SellLandLocation>
          <SellLandOnSale onSale={myToken.onSale}>
            {myToken.onSale ? `On sale for ${myToken.price / 1000000 } ꜩ` : "Not on sale"}
          </SellLandOnSale>
        </SellLandFirstRow>

        <SellLandSecondRow>
          {myToken.onSale ? (
             <>
             <CancelSaleButton
               onClick={() =>
                cancelSaleCallback({
                   token_id: myToken.id,
                   price: myToken.price,
                 })
               }
             >
               Cancell sale
             </CancelSaleButton>
           </>
          ) : (
            <>
              <SellLandPriceInput
                value={price}
                onChange={(e) => setPrice(e.target.value)}
                placeholder="Enter price"
              />
              <SellLandButton
                onClick={() =>
                  sellTokenCallback({
                    token_id: myToken.id,
                    price: parseFloat(price),
                  })
                }
              >
                Sell
              </SellLandButton>
            </>
          )}
        </SellLandSecondRow>
      </SellLandBottom>
    </SellLandStyled>
  );
};
