#[starknet::interface]
pub trait IGame<TContractState> {
    fn claimPoints (ref self: TContractState, _points: u256);
}

#[starknet::contract]
pub mod Game {

    use super::{IGame};
    use starknet::{ContractAddress, get_caller_address};

    use game_contract::erc20_interface::{IERC20Dispatcher, IERC20DispatcherTrait};

    #[constructor]
    fn constructor(ref self: ContractState, _token_addr: ContractAddress) {
        self.token_address.write(_token_addr);
    }

    #[storage]
    struct Storage {
        token_address: ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        RewardCliamed: RewardCliamed
    }


    #[derive(Drop, starknet::Event)]
    struct RewardCliamed {
        player: ContractAddress,
        amount: u256
    }

    #[abi(embed_v0)]
    impl GameImpl of IGame<ContractState> {
        fn claimPoints (ref self: ContractState, _points: u256) {
            let caller = get_caller_address();

            let strk_erc20_contract = IERC20Dispatcher {
                contract_address: self.token_address.read()
            };

            strk_erc20_contract.transfer(caller, _points);

            self.emit( RewardCliamed {player: caller, amount: _points});
        }
    }   

}

