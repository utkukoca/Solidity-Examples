// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC721.sol";

contract ERC721 is IERC721 {

    enum Statuses{Vacant,Occupied}
    Statuses currentStatus;
    uint HourFee = 0.0001 ether;
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;

    constructor(){
        currentStatus = Statuses.Vacant;
    }
    
    function balanceOf(address owner) external override view returns (uint256){
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) external override view returns (address){
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }
    //rentcar
    function rentcar(address payable owner, uint256 tokenId) external payable {
        require (_owners[tokenId] == msg.sender || _tokenApprovals[tokenId] == msg.sender);
        require(msg.value==HourFee);
        _transfer(owner,address(this),tokenId);
        owner.transfer(msg.value);
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

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }
    function mint(address to, uint256 tokenId) override external virtual  {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId);
    }
     function burn(uint256 tokenId) override external virtual {
        require (_owners[tokenId] == msg.sender || _tokenApprovals[tokenId] == msg.sender);
        address owner =msg.sender;

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId);
    }
  
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(msg.sender, to, tokenId);
    }
     function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}

    
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
