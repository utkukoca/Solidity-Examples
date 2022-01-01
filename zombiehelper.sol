pragma solidity ^0.8.4;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

    uint levelUpFee = 0.001 ether; //kullancılar level yükseltmek için değer transferleri yapmak zorunda.

    modifier aboveLevel(uint _level, uint _zombieId){
        
        require(zombies[_zombieId].level >= _level); //zombinin ıdsinden kaç levelde olduğunu bulup bu sayede bazı fonksiyonları sadece belli levelde olan zombilerin yapmasını sağlayabiliriz
        
        _;
    }

    function withdraw(address payable _owner) external onlyOwner{
      _owner = payable(address(_owner)); //bu sayede sadece kontrat sahibi çekebilir.
      _owner.transfer(address(this).balance); //anlık olarak kontrattaki ether değerini gösterir.

    }    
    function setLevelUpFee(uint _fee) external onlyOwner {
      levelUpFee = _fee; //eğer ether fiyatı artarsa kontratımız çok pahalı hale gelebilir bundan değiştirilebilir yapalım.
    }
    function levelUp (uint _zombieId) external payable {
      require(msg.value == levelUpFee); //msg.valuenın yani gönderilen değerin 0.001 eth eşit olması gerekiyor.
      zombies[_zombieId].level++ ; //en sonunda zombinin leveli yükseliyor.
    }
    
    function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) ownerOf(_zombieId) { //2 level ve üstü zombiler yapabilir ve bu zombiye sahip olması gerekiyor
      zombies[_zombieId].name = _newName; //bu şekilde zombinin ismini değiştirebilir.
    }

    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) ownerOf(_zombieId) { //20 level ve üstü zombiler yapabilir ve bu zombiye sahip olması gerekiyor
      zombies[_zombieId].dna = _newDna; //zombinin dnasını değiştirebilir.
    }
    function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
      uint[] memory result = new uint[](ownerZombieCount[_owner]);
      uint counter = 0;
      for (uint i = 0; i < zombies.length; i++) { //dizideki tüm zombiler için tekrarlanmasını sağlar
        if (zombieToOwner[i] == _owner) { //eğer o zombi varsa bu dizinin içine ekler.
          result[counter] = i;
          counter++; //elinde kaç tane tuttuğunu gösterir.
        }
        
      }
      
     return  result;
      
  }
    
    
}
