pragma solidity ^0.8.4;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
    
    modifier aboveLevel(uint _level, uint _zombieId){
        
        require(zombies[_zombieId].level >= _level); //zombinin ıdsinden kaç levelde olduğunu bulup bu sayede bazı fonksiyonları sadece belli levelde olan zombilerin yapmasını sağlayabiliriz
        
        _;
    }
    
    function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) { //2 level ve üstü zombiler yapabilir.
      require(msg.sender == zombieToOwner[_zombieId]); //bu zombiye sahip olması gerekiyor
      zombies[_zombieId].name = _newName; //bu şekilde zombinin ismini değiştirebilir.
    }

    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) { //20 level ve üstü zombiler yapabilir.
      require(msg.sender == zombieToOwner[_zombieId]); //bu zombiye sahip olması gerekiyor
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
