(**
Implementation of the FA2 interface for the TLD contract supporting multiple
types of NFTs. Each NFT type is represented by the range of token IDs - `token_def`.
 *)
#if !FA2_TLD_TOKEN
#define FA2_TLD_TOKEN

#include "tzip-12/fa2_interface.mligo"
#include "tzip-12/fa2_errors.mligo"
#include "tzip-12/lib/fa2_operator_lib.mligo"

#include "domain_storage/storage_definition.mligo"
#include "entrypoints/entrypoints.mligo"


type nft_entry_points =
    | Fa2 of fa2_entry_points
    | Metadata of fa2_token_metadata
    | Mint of mint_param
    | ChangeLandName of change_land_name_param
    | ChangeLandDescription of (nat * name)
    | SellLand of sell_param
    | BuyLand of buy_param
    | WithdrawFromSale of withdraw_param

let fa2_main (param, storage : fa2_entry_points * nft_token_storage)
    : (operation  list) * nft_token_storage =
    match param with
    | Transfer txs_michelson -> fa2_transfer (txs_michelson, storage)
    | Balance_of pm -> fa2_balance (pm, storage)
    | Update_operators updates_michelson -> fa2_update_operators (updates_michelson, storage)
    | Token_metadata_registry callback -> fa2_token_metadata_registry (callback, storage)

let main (param, storage : nft_entry_points * nft_token_storage)
      : (operation  list) * nft_token_storage =
    match param with
    | Fa2 fa2 -> fa2_main (fa2, storage)
    | Metadata m -> get_metadata_entrypoint(m, storage)
    | Mint p -> mint(p,storage)
    | ChangeLandName p -> change_land_name(p, storage)
    | ChangeLandDescription p -> changeLandDescription(p.0, p.1, storage)
    | SellLand p -> sell(p, storage)
    | BuyLand p -> buy(p, storage)
    | WithdrawFromSale p -> withdraw_from_sale(p, storage)


#endif




// ligo compile-contract land.mligo nft_token_main

//ligo compile-storage land.mligo nft_token_main '{ market = { lands = (Big_map.empty : (nat, land) big_map); admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)]) }; ledger = (Big_map.empty : (token_id, address) big_map); operators = (Big_map.empty : ((address * (address * nat)), unit) big_map); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=1n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'


// ADD OPERATOR
//ligo compile-storage land.mligo nft_token_main '{ market = { lands = (Big_map.empty : (nat, land) big_map); admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)]) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = (Big_map.empty : ((address * (address * nat)), unit) big_map); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=0n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'
//ligo compile-parameter land.mligo nft_token_main 'Fa2 (Update_operators([ operator_update_to_michelson (Add_operator_p({owner=("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address);operator=("tz1faswCTDciRzE4oJ9jn2Vm2dvjeyA9fUzU":address);token_id=1n})) ]))'
//ligo dry-run --sender=tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv land.mligo nft_token_main 'Fa2 (Update_operators([ operator_update_to_michelson (Add_operator_p({owner=("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address);operator=("tz1faswCTDciRzE4oJ9jn2Vm2dvjeyA9fUzU":address);token_id=1n})) ]))' '{ market = { lands = (Big_map.empty : (nat, land) big_map); admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)]) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = (Big_map.empty : ((address * (address * nat)), unit) big_map); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=0n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'

// TRANSFER BY OPERATOR
// ligo compile-storage land.mligo nft_token_main '{ market = { lands = (Big_map.empty : (nat, land) big_map); admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)]) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = Big_map.literal([ ((("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv": address), (("tz1faswCTDciRzE4oJ9jn2Vm2dvjeyA9fUzU":address), 1n)), unit) ]); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=0n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'
// ligo compile-parameter land.mligo nft_token_main 'Fa2 (Transfer( [ transfer_to_michelson ({from_=("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address); txs=[{to_=("tz1gjaF81ZRRvdzjobyfVNsAeSC6PScjfQwN": address); token_id=1n; amount=1n}]}) ]))'
// ligo dry-run --sender=tz1faswCTDciRzE4oJ9jn2Vm2dvjeyA9fUzU land.mligo nft_token_main 'Fa2 (Transfer( [ transfer_to_michelson ({from_=("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address); txs=[{to_=("tz1gjaF81ZRRvdzjobyfVNsAeSC6PScjfQwN": address); token_id=1n; amount=1n}]}) ]))' '{ market = { lands = (Big_map.empty : (nat, land) big_map); admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)]) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = Big_map.literal([ ((("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv": address), (("tz1faswCTDciRzE4oJ9jn2Vm2dvjeyA9fUzU":address), 1n)), unit) ]); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=0n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'

// REMOVE OPERATOR
//ligo compile-storage land.mligo nft_token_main '{ market = { lands = (Big_map.empty : (nat, land) big_map); admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)])  }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = Big_map.literal([ ((("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv": address), (("tz1faswCTDciRzE4oJ9jn2Vm2dvjeyA9fUzU":address), 1n)), unit) ]); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=0n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'
//ligo compile-parameter land.mligo nft_token_main 'Fa2 (Update_operators([ operator_update_to_michelson (Remove_operator_p({owner=("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address);operator=("tz1faswCTDciRzE4oJ9jn2Vm2dvjeyA9fUzU":address);token_id=1n})) ]))'
//ligo dry-run --sender=tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv land.mligo nft_token_main 'Fa2 (Update_operators([ operator_update_to_michelson (Remove_operator_p({owner=("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address);operator=("tz1faswCTDciRzE4oJ9jn2Vm2dvjeyA9fUzU":address);token_id=1n})) ]))' '{ market = { lands = (Big_map.empty : (nat, land) big_map); admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)]) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = Big_map.literal([ ((("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv": address), (("tz1faswCTDciRzE4oJ9jn2Vm2dvjeyA9fUzU":address), 1n)), unit) ]); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=0n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'

// METADATA
//ligo compile-storage land.mligo nft_token_main '{ market = { lands = (Big_map.empty : (nat, land) big_map); admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)]) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = (Big_map.empty : ((address * (address * nat)), unit) big_map); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=1n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'
//ligo compile-parameter land.mligo nft_token_main 'Metadata (Token_metadata(Layout.convert_to_right_comb(({ token_ids=[1n]; handler=fun (l : token_metadata_michelson list) -> unit }: token_metadata_param))))'
//ligo dry-run --sender=tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv land.mligo nft_token_main 'Metadata (Token_metadata(Layout.convert_to_right_comb(({ token_ids=[1n]; handler=fun (l : token_metadata_michelson list) -> unit }: token_metadata_param))))' '{ market = { lands = (Big_map.empty : (nat, land) big_map); admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)]) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = (Big_map.empty : ((address * (address * nat)), unit) big_map); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=1n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'

//ligo compile-parameter land.mligo nft_token_main 'Metadata (Token_metadata(Layout.convert_to_right_comb(({ token_ids=[1n]; handler=fun (tmml : token_metadata_michelson list) -> list.map  (fun (tmm: token_metadata_michelson) -> let tm = Layout.convert_from_right_comb(tmm) in if tm.decimals <> 0n then failwith("not a NFT") else unit) tmml }: token_metadata_param))))'

// CREATE LAND
// ligo compile-storage land.mligo nft_token_main '{ market = { lands = Big_map.literal [(1n, { name = "terrain_1"; description = Some("description_1"); position = (0n, 0n); isOwned = true; onSale = false; price = 200mutez; id = 1n })]; admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)]) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = (Big_map.empty : ((address * (address * nat)), unit) big_map); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=1n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'
// ligo compile-parameter land.mligo nft_token_main 'CreateLand( { name = "nom"; description = (None : string option); position = (1n, 0n); isOwned = true; onSale = false; price = 200mutez; id = 2n } )'
// ligo dry-run land.mligo nft_token_main 'CreateLand( { name = "nom"; description = (None : string option); position = (1n, 0n); isOwned = true; onSale = false; price = 200mutez; id = 2n } )' '{ market = { lands = Big_map.literal [(1n, { name = "terrain_1"; description = Some("description_1"); position = (0n, 0n); isOwned = true; onSale = false; price = 200mutez; id = 1n })]; admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)]) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = (Big_map.empty : ((address * (address * nat)), unit) big_map); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=1n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'

// MINT
// ligo compile-storage land.mligo nft_token_main '{ market = { lands = Big_map.literal [(1n, { name = "terrain_1"; description = Some("description_1"); position = (0n, 0n); isOwned = true; onSale = false; price = 200mutez; id = 1n })]; admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)]) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = (Big_map.empty : ((address * (address * nat)), unit) big_map); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=1n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'
// ligo compile-parameter land.mligo nft_token_main 'Mint( { token_id=10n; owner=("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address); operator=(None: address option) } )'
// ligo dry-run --amount=0.0002 --sender=tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv land.mligo nft_token_main 'Mint( { token_id=2n; owner=("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address); operator=(None: address option) } )' '{ market = { availables=(Set.add 2n (Set.empty : token_id set)); lands = Big_map.literal [(1n, { name = "terrain_1"; description = Some("description_1"); position = (0n, 0n); isOwned = true; onSale = false; price = 200mutez; id = 1n })]; admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)]) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = (Big_map.empty : ((address * (address * nat)), unit) big_map); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=1n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'


// CHANGE LAND NAME
// ligo compile-parameter land.mligo nft_token_main 'ChangeLandName( (1n, "sdfxgjkljjhfgdgs"))'
// ligo dry-run land.mligo nft_token_main 'ChangeLandName( (1n, "sdfxgjkljjhfgdgs"))' '{ market = { lands = Big_map.literal [(1n, { name = "terrain_1"; description = Some("description_1"); position = (0n, 0n); isOwned = true; onSale = false; price = 200mutez; id = 1n })]; admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)]) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = (Big_map.empty : ((address * (address * nat)), unit) big_map); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=1n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'

// SELL LAND
// ligo compile-storage land.mligo nft_token_main '{ market = { lands = Big_map.literal [(1n, { name = "terrain_1"; description = Some("description_1"); position = (0n, 0n); isOwned = true; onSale = false; price = 200mutez; id = 1n })]; admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=(Big_map.empty: (token_id, price) big_map) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = (Big_map.empty : ((address * (address * nat)), unit) big_map); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=1n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'
// ligo compile-parameter land.mligo nft_token_main 'SellLand({id=1n; price=100mutez})'
// ligo dry-run land.mligo nft_token_main 'SellLand({id=1n; price=100mutez})' '{ market = { lands = Big_map.literal [(1n, { name = "terrain_1"; description = Some("description_1"); position = (0n, 0n); isOwned = true; onSale = false; price = 200mutez; id = 1n })]; admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=(Big_map.empty: (token_id, price) big_map) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = (Big_map.empty : ((address * (address * nat)), unit) big_map); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=1n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'
// ligo dry-run --sender="tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv" land.mligo nft_token_main 'SellLand({id=1n; price=100mutez})' '{ market = { lands = Big_map.literal [(1n, { name = "terrain_1"; description = Some("description_1"); position = (0n, 0n); isOwned = true; onSale = false; price = 200mutez; id = 1n })]; admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=(Big_map.empty: (token_id, price) big_map) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = (Big_map.empty : ((address * (address * nat)), unit) big_map); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=1n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'

// BUY LAND (not working due to "FA2_NOT_OPERATOR")
// ligo compile-storage land.mligo nft_token_main '{ market = { lands = Big_map.literal [(1n, { name = "terrain_1"; description = Some("description_1"); position = (0n, 0n); isOwned = true; onSale = false; price = 200mutez; id = 1n })]; admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)]) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = Big_map.literal([ ((("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv": address), (("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address), 1n)), unit) ]); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=1n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'
// ligo compile-parameter land.mligo nft_token_main 'BuyLand({id=1n})'
// (echoue sur le montant) ligo dry-run --sender="tz1LFuHW4Z9zsCwg1cgGTKU12WZAs27ZD14v" land.mligo nft_token_main 'BuyLand({id=1n})' '{ market = { lands = Big_map.literal [(1n, { name = "terrain_1"; description = Some("description_1"); position = (0n, 0n); isOwned = true; onSale = false; price = 200mutez; id = 1n })]; admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)]) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = Big_map.literal([ ((("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv": address), (("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address), 1n)), unit) ]); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=1n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'
// ligo dry-run --amount=0.0001 --sender="tz1LFuHW4Z9zsCwg1cgGTKU12WZAs27ZD14v" land.mligo nft_token_main 'BuyLand({id=1n})' '{ market = { lands = Big_map.literal [(1n, { name = "terrain_1"; description = Some("description_1"); position = (0n, 0n); isOwned = true; onSale = false; price = 200mutez; id = 1n })]; admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)]) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = Big_map.literal([ ((("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv": address), (("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address), 1n)), unit) ]); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=1n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'
// (echoue sur le montant) // ligo dry-run --amount=0.0002 --sender="tz1LFuHW4Z9zsCwg1cgGTKU12WZAs27ZD14v" land.mligo nft_token_main 'BuyLand({id=1n})' '{ market = { lands = Big_map.literal [(1n, { name = "terrain_1"; description = Some("description_1"); position = (0n, 0n); isOwned = true; onSale = false; price = 200mutez; id = 1n })]; admin = ("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address); height=10n; width=10n; sales=Big_map.literal ([(1n, 100mutez)]) }; ledger = Big_map.literal([(1n,("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv":address))]); operators = Big_map.literal([ ((("tz1b7tUupMgCNw2cCLpKTkSD1NZzB5TkP2sv": address), (("tz1ibMpWS6n6MJn73nQHtK5f4ogyYC1z9T9z":address), 1n)), unit) ]); metadata = { token_defs = Set.add {from_=1n; to_=100n} (Set.empty : token_def set); last_used_id = 1n; metadata = Big_map.literal([ ({from_=1n;to_=100n},{token_id=1n; symbol="TLD"; name="TezosLand"; decimals=0n; extras=(Map.empty :(string, string) map)}) ]) }}'
