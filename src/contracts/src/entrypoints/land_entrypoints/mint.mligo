#include "../../domain_storage/storage_definition.mligo"
#include "../helpers/fa2_transfer_helpers.mligo"
#include "../helpers/land_transfer_helpers.mligo"

type mint_param = {
    token_id: token_id;
    owner: address;
    operator: address option;
}
(**
Create a land, and a token (they both have the same id), associate token to given owner, (and possibly setup an operator for this newly minted token)
@return storage with new token, and operators
*)
let mint (mint_param, store : mint_param * nft_token_storage) : (operation  list) * nft_token_storage =
    // if not is_admin(Tezos.sender, store.market)
    // then (failwith("need admin privilege") : (operation  list) * nft_token_storage)
    // else

    let create_token_with_operator (p,s : mint_param * nft_token_storage) : (operation  list) * nft_token_storage =
       // TODO: default price .. payment to
       if (Tezos.amount = 200mutez) then
        let new_owners: owners = add_token_to_owner (p.token_id, p.owner, s.market.owners) in
        let ledgder_with_minted_token = Big_map.add p.token_id p.owner s.ledger in
        let new_land = ({ name=""; description=(None:string option); position=convert_index_to_position(p.token_id, s.market); isOwned=true; onSale=false; price=200mutez; id=p.token_id }:land) in
        let lands_with_new_land = Big_map.add p.token_id new_land s.market.lands in
        match mint_param.operator with
        | None -> ([] : operation list),  { s with ledger = ledgder_with_minted_token; market = { s.market with lands=lands_with_new_land; owners=new_owners; } }
        | Some(operator_address) ->
            let update : update_operator = Add_operator_p({ owner = p.owner; operator = operator_address; token_id = p.token_id; }) in
            let operators_with_minted_token_operator = update_operators (update, s.operators) in
            ([] : operation list),  { s with ledger = ledgder_with_minted_token; operators = operators_with_minted_token_operator; market = { s.market with lands=lands_with_new_land; owners=new_owners; } }
      else
        (failwith("Default mint price is 200mutez") : (operation  list) * nft_token_storage)
    in

    let token_owner_option : address option = Big_map.find_opt mint_param.token_id store.ledger in
    match token_owner_option with
    | Some(ownr) -> (failwith("This non-fungible token already exists"): (operation  list) * nft_token_storage)
    | None -> create_token_with_operator (mint_param, store)
