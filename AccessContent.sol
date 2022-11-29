// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @title A custom ERC1155 contract.
/// @author duvanvilladiego
/// @notice Serves as a generator of NFT for the AccessContent.
/// @dev Inherits the OpenZepplin ERC1155 implentation, Ownable, ERC1155Supply.
contract AccessContent is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    ///Minter user
    mapping (uint => address) private _minter;
    ///Receivers users
    mapping (address => address[]) private _receivers;
    ///Burnin Tokens
    mapping (address => uint[]) private _burnins;
    ///User hashes related
    mapping (string => address) private _hashes;

    address private AccesContentContract;

    ///@dev restrict see the token uri
    modifier tokenHolder(uint _tokenId) {
        require(msg.sender == ownerOf(_tokenId), "You not the token Owner");
        _;
    }

    ///@dev restrict functions only to token minter
    modifier onlyMinter(uint _tokenId) {
        require(msg.sender == _minter[_tokenId], "You not the minter of this token");
        _;
    }

    ///@dev restrict token transfers
    modifier noTransfer() {
        require(false,"The token cant be transfer");
        _;
    }

    ///@notice Deploys the smart contract.
    constructor() ERC721("AccessContentToken", "ACT"){} 


    //============================== Multimedia mint save tokens ==============================//
    ///@dev add new token receivers
    function addNewReceiver(address _receiver) external {
        _receivers[msg.sender].push(_receiver);
    }

    ///@dev hash identifier functions
    ///This function save the hash token data to _hashed mapping
    function saveMultimedia(string memory _hash) public returns(bool) {
        require(_receivers[msg.sender].length>0, "Cant upload content without receivers");
        address _owner = msg.sender;
        _hashes[_hash] = _owner;
        safeMuntiMinter(_hash);
        return (_hashes[_hash] == _owner);
    }

    ///@dev this function mint tokens for a array of address
    function safeMuntiMinter(string memory _uri) private {
        require(_receivers[msg.sender].length>0, "Cant upload content without receivers");
        address[] storage to = _receivers[msg.sender];
        to.push(msg.sender);
        for (uint i = 0; i < to.length; i++) 
        {
            safeMint(to[i],_uri);
        }
    }

    ///@dev this function mint new tokens
    function safeMint(address _to, string memory _uri) private {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _minter[tokenId] = msg.sender;
        _safeMint(_to, tokenId);
        _setTokenURI(tokenId, _uri);
    }

    //============================== Multimedia burns tokens ==============================//
    ///@dev add new token receivers
    function addTokenToBurn(uint _tokenId) external {
        _burnins[msg.sender].push(_tokenId);
    }

    ///@dev Burn tokens
    function burnTokens() public {
        uint[] storage _burns = _burnins[msg.sender];
        for (uint i = 0; i < _burns.length; i++) 
        {
            _burn(_burns[i]);
        }
    }

    ///@notice The following functions are overrides required by Solidity.
    function _burn(uint256 _tokenId) internal override(ERC721, ERC721URIStorage) onlyMinter(_tokenId) {
        super._burn(_tokenId);
    }

    ///@notice Override functions
    ///@dev override function with the tokenHolder modifier
    function tokenURI(uint256 _tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        tokenHolder(_tokenId)
        returns (string memory)
    {
        return super.tokenURI(_tokenId);
    }

    ///@dev restrict tokens tranfers
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721) noTransfer() {}
}