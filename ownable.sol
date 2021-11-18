pragma  solidity  ^0.8.4;

contract Ownable{
    address private _owner;
     
    event OwnershipTransferred(
      address indexed previousOwner,
      address indexed newOwner
    );
    constructor() { //akıllı kontratı yükleyen kişinin owner olduğunu gösterir.
       _owner = msg.sender; 
       emit OwnershipTransferred(address(0), _owner);
    }
    function owner() public view returns(address) { //ownerın kim olduğunu kullanıcıya gösterir.
       return _owner;
    }
    
    modifier onlyOwner() {
       require(isOwner()); //akıllı kontratı kullanan kişi owner olup olmadığını sorgulayabilir.
       _;
    }
    function isOwner() public view returns(bool) {
       return msg.sender == _owner;}
    
    function renounceOwnership() public onlyOwner {
       emit OwnershipTransferred(_owner, address(0)); 
       _owner = address(0); //ownerlığı ortadan kaldırmaya yarar (merkeziyetsiz olur).
    }
    
    function transferOwnership(address newOwner) public onlyOwner {
       _transferOwnership(newOwner);
    }
    function _transferOwnership(address newOwner) internal {
       require(newOwner != address(0));
       emit OwnershipTransferred(_owner, newOwner);
       _owner = newOwner; //ownerlığın başka bir adrese aktarılmasını sağlar.
  }
    
    
}
