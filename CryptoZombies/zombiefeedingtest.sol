pragma  solidity  ^0.8.4;

import "./zombiefactory.sol";

abstract contract KittyInterface { //zombilerimizi beslemek için CryptoKittieleri kullanalım bunun için kriptokedilerin genlerini okumamız gerekir
  function getKitty(uint256 _id) external virtual view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory{

    
    
    KittyInterface kittyContract;

    modifier ownerOf(uint _zombieId) {
      require(msg.sender == zombieToOwner[_zombieId]); //değiştirmek için bu zombiye sahip olunması gerekiyor
      _;
    }

    function setKittyContractAddress(address _address) external onlyOwner{ //bu sayede eğer CryptoKitties kontratına bir şey olursa bile istediğimiz zaman değiştirebileceğiz şimdilik herks değiştirebiliyor sonraki güncellemde sadece owner değiştirebilecek. 
      kittyContract = KittyInterface(_address);}
    
    function _triggerCooldown(Zombie storage _zombie) internal {
        
        _zombie.readyTime=uint32(block.timestamp + cooldownTime);
        
    }
    
    function _isReady (Zombie storage _zombie) internal view returns(bool){
        
       return(_zombie.readyTime <= block.timestamp);
    }
    
    function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal ownerOf(_zombieId) {
        
        Zombie storage myZombie = zombies[_zombieId]; //bu zombinin dnasını almak için bunu kullanmalıyız.
        require(_isReady(myZombie));
        _targetDna = _targetDna % dnaModule;//hedef dnamızın 16 haneli olması gerekiyor
        uint newDna = (_targetDna + myZombie.dna) / 2; //yeni dnayı bu şekilde bir formülle oluşturabilriz
        if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) { //eğer zombiler CryptoKittieleri yedilerse bunu özelleştirelim ve dnasın son 2 hanesini 99 yapalım
          newDna = newDna - newDna % 100 + 99;
    }
        createZombie("NoName",newDna);
        _triggerCooldown(myZombie);
    }
    
    function feedOnKitty (uint _zombieId ,uint _kittyId) public{
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);//_kittyId sayesinde .getKittyi çağıralım ve genleri kittydnada depolayalım.
        feedAndMultiply(_zombieId,_kittyId,"kitty");
        
        
        
    }
    
    
    
    
    
}
