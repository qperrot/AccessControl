const DEFAULT_ADMIN_ROLE: felt252 = 0;
const IACCESSCONTROL_ID: u32 = 0x7965db0b_u32;

#[contract]
mod AccessControl {
    use zeroable::Zeroable;
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use test::access::AccessControl;
    use openzeppelin::introspection::erc165::ERC165;

    struct Storage {
        AccessControl_role_admin: LegacyMap::<felt252, felt252>,
        AccessControl_role_member: LegacyMap::<(felt252, ContractAddress), bool>,
    }

    ////////////////////////////////
    // EVENTS
    ////////////////////////////////

    #[event]
    fn RoleGranted(role: felt252, account: ContractAddress, sender: ContractAddress) {}

    #[event]
    fn RoleRevoked(role: felt252, account: ContractAddress, sender: ContractAddress) {}

    #[event]
    fn RoleAdminChanged(role: felt252, previousAdminRole: felt252, newAdminRole: felt252) {}


    fn initializer() {
        erc165::ERC165::register_interface(AccessControl::IACCESSCONTROL_ID);
        return ();
    }

    ////////////////////////////////
    // MODIFIER
    ////////////////////////////////

    fn assert_only_role(role: felt252) {
        let caller = get_caller_address();
        let authorized = has_role(role, caller);
        assert(authorized == true, 'caller is missing role');
    }

    ////////////////////////////////
    // GETTERS
    ////////////////////////////////

    fn has_role(role: felt252, user: ContractAddress) -> bool {
        AccessControl_role_member::read((role, user))
    }

    #[view]
    fn get_role_admin(role: felt252) -> felt252 {
       AccessControl_role_admin::read(role)
    }

    ////////////////////////////////
    // EXTERNALS
    ////////////////////////////////

    #[external]
    fn grant_role(role: felt252, user: ContractAddress) {
        let admin = get_role_admin(role);
        assert_only_role(admin);
        _grant_role(role, user);
    }

    #[external]
    fn revoke_role(role: felt252, user: ContractAddress) {
        let admin = get_role_admin(role);
        assert_only_role(admin);
        _revoke_role(role, user);
    }

    #[external]
    fn renounce_role(role: felt252, user: ContractAddress) {
        let caller = get_caller_address();
        assert(user == caller, 'user is not caller');
        _revoke_role(role, user);
        return ();
    }

    ////////////////////////////////
    // UNPROTECTED
    ////////////////////////////////

    fn _grant_role(role: felt252, user: ContractAddress) {
        let user_has_role = has_role(role, user);
        if (user_has_role == false) {
            let caller = get_caller_address();
            AccessControl_role_member::write((role, user), true);
            RoleGranted(role, user, caller);
            return ();
        }
        return ();
    }

    fn _revoke_role(role: felt252, user: ContractAddress) {
        let user_has_role = has_role(role, user);
        if (user_has_role == true) {
            let caller = get_caller_address();
            AccessControl_role_member::write((role, user), false);
            RoleRevoked(role, user, caller);
            return ();
        }
        return ();
    }

    fn _set_role_admin(role: felt252, admin_role: felt252) {
        let previous_admin_role = get_role_admin(role);
        AccessControl_role_admin::write(role, admin_role);
        RoleAdminChanged(role, previous_admin_role, admin_role);
        return ();
    }
}