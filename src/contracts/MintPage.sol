// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/access/Ownable.sol";
import "https://github.com/Brechtpd/base64/blob/main/base64.sol";

contract studyjoin is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenCounter;

    bool public revealFlg = false;
    bool public saleFlg = false;
    //bytes public secretURL = "";
    //bytes public baseURL = "https://gateway.pinata.cloud/ipfs/QmUJTnUaF28dvVj6xWKfywhRhx7WKhU4aHm1BdUb3HxUQc";

    mapping(address => uint256) private _addressToApprove;

    constructor () ERC721 ("YumeWeb3Study","YWS") {}

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {

        bytes memory json = abi.encodePacked(
            '{',
                '"name": "MintPage #',
                Strings.toString(tokenId),
                '",',
                '"description": "",',
                '"image": "https://gateway.pinata.cloud/ipfs/QmUJTnUaF28dvVj6xWKfywhRhx7WKhU4aHm1BdUb3HxUQc"',
            '}'
        );

        bytes memory metadata = abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        );

        return (string(metadata));
    }

    function mint() public {
        require(saleFlg);
        require(_addressToApprove[_msgSender()] == 0);

        _tokenCounter.increment();
        uint256 newItemId = _tokenCounter.current();

        _safeMint(_msgSender(), newItemId);
        _setTokenURI(newItemId, tokenURI(newItemId));

        _addressToApprove[_msgSender()] = 1;
    }

    function changeSaleFlg() public onlyOwner {
        saleFlg = true;
    }

    function changeRevealFlg() public onlyOwner {
        revealFlg = true;
    }

    function getAddressApprove() public view returns(uint256){
        return _addressToApprove[_msgSender()];
    }

    function getSupply()public view returns(uint256){
        return _tokenCounter.current();
    }

}