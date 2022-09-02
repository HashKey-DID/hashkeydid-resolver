// SPDX-License-Identifier: LGPL-3.0-or-later
pragma solidity ^0.8.0;

interface DID {
    function isAddrAuthorized(uint256 tokenId, address addr) external view returns (bool);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
    function ownerOf(uint256 tokenId) external view returns (address);
    function tokenId2Did(uint256 tokenId)external view returns (string memory);
}

contract ResolverStorage {

    DID did;

    mapping(uint256 => mapping(uint256 => bytes)) _addresses;

    mapping(uint256 => bytes) _contentHashes;

    mapping(address => bool) _isReverse;

    struct PublicKey {
        bytes32 x;
        bytes32 y;
    }
    mapping(uint256 => PublicKey) _pubkeys;

    mapping(uint256 => mapping(string => string)) _texts;
}
