pragma solidity ^0.8.4;

import "./zombiehelper.sol";

contract ZombieAttack is ZombieHelper {
   uint randNonce = 0;
   uint attackVictoryProbability =70;


   function randMod(uint _modulus) internal returns(uint) { //solidityde rastgele sayı üreteilmez bu method o yüzden güvenilir değildir!!
    randNonce++; //bu sayı git gide artar
    return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus; //bu 3 veriyi kullanarak keccak256 ile bir hash fonkisyonu oluşturulur ve son iki rakamı rastgele alınır.
  }
   function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) { //bizim zombimizin ve saldırı yapacağımız karşı zombinin ıdsi gereklidir.
      Zombie storage myZombie = zombies[_zombieId]; //daha kolay iletişme geçebilmemiz için storage işaretçisini kullanalım.
      Zombie storage enemyZombie = zombies[_targetId];

      uint rand = randMod(100); //sonucumuzu 0 ile 99 dahil ve arasında bir değer istiyoruz.
      if (rand <= attackVictoryProbability) { //eğer rakam 70e eşit ve küçükse (yani %70 kazanma oranı var) aşağıdakileri yapar.
      myZombie.winCount++; //zombimizin kazanma sayısı artar.
      myZombie.level++; //zombimizin leveli artar
      enemyZombie.lossCount++; //rakip zombinin kaybetme sayısı artar.
      feedAndMultiply(_zombieId, enemyZombie.dna, "zombie"); 
      }else { //eğer bizim zombimiz kaybederse
      myZombie.lossCount++; //zombimizin kaybetme sayısı artar.
      enemyZombie.winCount++; //rakip zombinin kazanma sayısı artar.
      _triggerCooldown(myZombie); //bu sayede günlük sadece 1 kere saldırı yapılabilir bu zaten feedAndMultiply içinde çalıştığı içi kaybetsede kaybetmesede tetikleniyor.
      }
  }


}
