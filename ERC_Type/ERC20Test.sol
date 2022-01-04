pragma solidity ^0.8.4;

import "./IERC20Test.sol";

contract ERC2OTest is IERC20Test {
    string public constant symbol= "UTK"; // token sembolü.
    string public constant name ="Utku Token"; // token adı.
    uint8 public constant decimals= 18; // token basamağı.
    uint256 private constant totalSupply_ =10000; // tokenın toplam sayısı.
    
    mapping (address=>uint) private balances_;
    mapping (address=>mapping (address=>uint)) private allowance_;
    
    constructor() public {
            balances_[msg.sender] = totalSupply_;
    }
    
    function totalSupply() public view virtual override returns (uint256) {
        return totalSupply_;
    }
    function balanceOf(address account) public view virtual override returns (uint256) {
        return balances_ [account];
    }
    function transfer(address recipient,uint256 amount)public virtual override returns (bool success) {
        if (amount<=balanceOf(msg.sender)){
            balances_[msg.sender]-=amount;
            balances_[recipient]+=amount;
            return true;
        }
        return false;
    }
    
    function allowance(address owner, address spender) public view virtual override returns (uint256){
        return allowance_[owner][spender];
        
        
    }
    function approve(address spender, uint256 amount) public virtual override returns (bool success){
        allowance_[msg.sender][spender] = amount;
        return true;
        
        
    }
   
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual returns (bool success){
         if (allowance_[sender][msg.sender] > 0 &&
            amount > 0 &&
            allowance_[sender][msg.sender] >= amount && 
            balances_[sender] >= amount) {
            balances_[sender] -= amount;
            balances_[recipient] += amount;
            allowance_[sender][msg.sender] -= amount;
            return true;
        }
        return false;
        
        
    }
    
    
    
    
    
}
