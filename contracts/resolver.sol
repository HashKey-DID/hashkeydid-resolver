// SPDX-License-Identifier: LGPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "./resolverStorage.sol";

contract Resolver is ResolverStorage, Initializable {

    /// @dev Emitted when change address successfully 
    event AddressChanged(uint256 tokenId, uint coinType, bytes newAddress);
    /// @dev Emitted when change content hash successfully 
    event ContentHashChanged(uint256 indexed tokenId, bytes cid);
    /// @dev Emitted when change public key hash successfully 
    event PubkeyChanged(uint256 indexed tokenId, bytes32 x, bytes32 y);
    /// @dev Emitted when change text successfully 
    event TextChanged(uint256 indexed tokenId, string key, string value);
    /// @dev Emitted when the reverse status is changed
    event ReverseChanged(address indexed addr, bool isReverse);

    /// @dev Permits modifications only by the owner of tokenId
    modifier authorized(uint256 tokenId) {
        require(did.ownerOf(tokenId) == msg.sender, "authorize fail");
        _;
    }

    /// @dev Initialize only once
    /// @param DIDAddr DID contract address
    function initialize (
        address DIDAddr
    ) 
        public 
        initializer 
    {
        did = DID(DIDAddr);
    }

    /// @dev Set whether reverse the address to did
    /// @param _addr address of user
    /// @param isReverse true/false
    function setReverse(address _addr, bool isReverse) public {
        require(_addr == msg.sender, "authorize fail");
        _isReverse[_addr] = isReverse;
        emit ReverseChanged(_addr, isReverse);
    }

    /// @dev Get the did name from the addr
    /// @param _addr address of user
    function name(address _addr) public view returns (string memory) {
        require(_isReverse[_addr], "this addr has not set reverse record");
        uint256 tokenId = did.tokenOfOwnerByIndex(_addr, 0);
        return did.tokenId2Did(tokenId);
    }

    /// @dev Sets DID different address on different chain
    /// @param tokenId The tokenId to query
    /// @param coinType The type of chains
    /// @param _addr The chain's address(bytes type)
    function setAddr(uint256 tokenId, uint256 coinType, bytes memory _addr) public authorized(tokenId) {
        _addresses[tokenId][coinType] = _addr;
        emit AddressChanged(tokenId, coinType, _addr);
    }

    /// @dev Check address on different chain
    /// @param tokenId The tokenId to query
    /// @param coinType The type of chains
    function addr(uint256 tokenId, uint256 coinType) public view returns(bytes memory) {
        return _addresses[tokenId][coinType];
    }

    /// @dev Sets tokenId's content hash(ipfs/CID)
    /// @param tokenId The tokenId to query
    /// @param cid The hash value of content in the ipfs net
    function setContentHash(uint256 tokenId, bytes calldata cid) external authorized(tokenId) {
        _contentHashes[tokenId] = cid;
        emit ContentHashChanged(tokenId, cid);
    }
    
    /// @dev Check tokenId's content hash(ipfs/CID)
    /// @param tokenId The tokenId to query
    function contentHash(uint256 tokenId) external view returns (bytes memory) {
        return _contentHashes[tokenId];
    }

    /// @dev Sets the SECP256k1 public key associated with a did
    /// @param tokenId The tokenId to query
    /// @param x The X coordinate of the curve point for the public key
    /// @param y The Y coordinate of the curve point for the public key
    function setPubkey(uint256 tokenId, bytes32 x, bytes32 y) external authorized(tokenId) {
        _pubkeys[tokenId] = PublicKey(x, y);
        emit PubkeyChanged(tokenId, x, y);
    }

    /// @dev Gets the SECP256k1 public key associated with a did
    /// @param tokenId The tokenId to query
    function pubkey(uint256 tokenId) external view returns (bytes32 x, bytes32 y) {
        return (_pubkeys[tokenId].x, _pubkeys[tokenId].y);
    }

    /// @dev Sets the text information associated with a did
    /// @param tokenId The tokenId to query
    /// @param key The key of info
    /// @param value The value of info
    function setText(uint256 tokenId, string calldata key, string calldata value) external authorized(tokenId) {
        _texts[tokenId][key] = value;
        emit TextChanged(tokenId, key, value);
    }

    /// @dev Gets the text information associated with a did
    /// @param tokenId The tokenId to query
    /// @param key The key of info
    function text(uint256 tokenId, string calldata key) external view returns (string memory) {
        return _texts[tokenId][key];
    }
}
