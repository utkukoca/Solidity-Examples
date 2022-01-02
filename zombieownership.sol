pragma solidity ^0.8.4;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, IERC721 {

  mapping (uint=>address) zombieApprovals; //yalnızca token sahibi veya onaylanan hesap yapabilir.
  

  function balanceOf(address _owner) override external view returns (uint256) {
    return ownerZombieCount[_owner]; //bir hesapta kaçtane token olduğu.
  }

  function ownerOf(uint256 _tokenId) override external view returns (address) {
    return zombieToOwner[_tokenId]; //hesaptaki token ıdleri
  }
  function _transfer(address _from, address _to, uint256 _tokenId) private { 
    ownerZombieCount[_to] = ownerZombieCount[_to].add(1); //transferden sonra gönderendeki token sayısı artar
    ownerZombieCount[_from] = ownerZombieCount[_from].sub(1); //transferden sonra gönderendeki token sayısı artar
    zombieToOwner[_tokenId] = _to; //tokenıdsi alıcıya geçer
    emit Transfer(_from, _to, _tokenId); //transferi başlatacak argümanları gösterir.

  }

  function transferFrom(address _from, address _to, uint256 _tokenId) override external  {
    require (zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender); //yalnızca token sahibi veya onaylanan hesap gereklidir.
    _transfer(_from, _to, _tokenId);


  }

  function approve(address _approved, uint256 _tokenId) override external onlyOwnerOf(_tokenId){
      zombieApprovals[_tokenId] = _approved; //yeni onaylanan hesap ve token ıdsi.
      emit Approval(msg.sender, _approved, _tokenId);

  }
}
