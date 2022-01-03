// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC721.sol";

contract ERC721 is IERC721 {
    
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    
    function balanceOf(address owner) external override view returns (uint256){
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) external override view returns (address){
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    function _transfer(address from, address to, uint256 tokenId) private { 
        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
    emit Transfer(from, to, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) override external  {
    require (_owners[tokenId] == msg.sender || _tokenApprovals[tokenId] == msg.sender); //yalnızca token sahibi veya onaylanan hesap gereklidir.
    _transfer(from, to, tokenId);
    }

    function approve(address to, uint256 tokenId) public virtual override {
        
        

    

        _approve(to, tokenId);
    }
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(msg.sender, to, tokenId);
    }


}