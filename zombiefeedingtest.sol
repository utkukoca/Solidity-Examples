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

    function setKittyContractAddress(address _address) external { //bu sayede eğer CryptoKitties kontratına bir şey olursa bile istediğimiz zaman değiştirebileceğiz ve bunu sadece ownable yapabilecek.
      kittyContract = KittyInterface(_address);}
    
    function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
        require (msg.sender == zombieToOwner[_zombieId] ); //birinin o zombiyi besleyebilmesi için o zombiye sahip olması lazım.
        Zombie storage myZombie = zombies[_zombieId]; //bu zombinin dnasını almak için bunu kullanmalıyız.
        _targetDna = _targetDna % dnaModule;//hedef dnamızın 16 haneli olması gerekiyor
        uint newDna = (_targetDna + myZombie.dna) / 2; //yeni dnayı bu şekilde bir formülle oluşturabilriz
        if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) { //eğer zombiler CryptoKittieleri yedilerse bunu özelleştirelim ve dnasın son 2 hanesini 99 yapalım
          newDna = newDna - newDna % 100 + 99;
    }
        createZombie("NoName",newDna);
    }
    
    function feedOnKitty (uint _zombieId ,uint _kittyId) public{
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);//_kittyId sayesinde .getKittyi çağıralım ve genleri kittydnada depolayalım.
        feedAndMultiply(_zombieId,_kittyId,"kitty");
        
        
        
    }
    
    
    
    
    
}
