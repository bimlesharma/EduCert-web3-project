// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTCertificate is ERC721URIStorage, Ownable {
    uint256 private _tokenIdCounter;
    
    // Mapping of certificate ID to NFT token ID
    mapping(bytes32 => uint256) public certificateToToken;

    // Pass msg.sender as the initial owner
    constructor() ERC721("EduChainCertificate", "EDUCert") Ownable(msg.sender) {}

    // Mint an NFT certificate with a random certificate ID
    function issueCertificate(address recipient, string memory tokenURI) public onlyOwner {
        uint256 newTokenId = _tokenIdCounter;
        bytes32 certificateId = keccak256(abi.encodePacked(block.timestamp, recipient, newTokenId));

        _safeMint(recipient, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        
        // Store the certificate ID mapping
        certificateToToken[certificateId] = newTokenId;

        _tokenIdCounter++;
    }

    // Verify if a certificate ID is valid
    function verifyCertificate(bytes32 certificateId) public view returns (bool, uint256) {
        uint256 tokenId = certificateToToken[certificateId];
        return (tokenId != 0, tokenId);
    }
}
