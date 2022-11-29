
# Solidity API

## Player

Generate Authorization tokens and transactions for content access.

_Inherits the OpenZepplin ERC1155Holder implentation, Ownable._

### _hashes

```solidity
mapping (string => address payable) private _hashes
```

_User hashes related._

### accessPlayerTokenContract

```solidity
address accessPlayerTokenContract
```

_The Access Player Token Contract Address._

### saveMultimedia

```solidity
function saveMultimedia( address  payable _owner, string  memory _hash )  public  returns(bool)
```

This function save the hash token data to _hashed mapping.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _owner| address | The account address of the multimedia file. |
| _hash| string | The hash of the multimedia file. |

####  Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool| Success flag. |

### find

```solidity
function find( address  payable _owner, string  memory _hash)  public  view  returns(bool)
```

This function save the hash token data to _hashed mapping.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _owner| address | The account address of the multimedia file. |
| _hash| string | The hash of the multimedia file. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool| Success flag. |
