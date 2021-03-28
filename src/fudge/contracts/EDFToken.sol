// SPDX-License-Identifier: UNLICENSED

pragma solidity >0.7.0;

interface IERC20 {
  function name() external view returns (string memory);
  function symbol() external view returns (string memory);
  function decimals() external view returns (uint8);
  function totalSupply() external view returns (uint256);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0, "SafeMath: division by zero");
    uint256 c = a / b;
    return c;
  }
}

contract EDFToken is IERC20 {
  string private _name = "EDF Token";
  string private _symbol = "EDF";
  uint8 private _decimals = 0;
  uint256 private _totalSupply;

  mapping (address => uint256) private _balances;
  mapping (address => mapping (address => uint256)) private _allowances;

  using SafeMath for uint256;

  constructor(uint256 initialSupply) {
      _totalSupply = initialSupply.mul(10 ** _decimals);
      _balances[msg.sender] = _totalSupply;
  }

  /**
    * @dev Returns the name of the token.
    */
  function name() external view override returns (string memory) {
    return _name;
  }

  /**
    * @dev Returns the symbol of the token.
    */
  function symbol() external view override returns (string memory) {
    return _symbol;
  }

  /**
    * @dev Returns the decimals places of the token.
    */
  function decimals() external view override returns (uint8) {
    return _decimals;
  }
  
  /**
    * @dev Returns the amount of tokens in existence.
    */
  function totalSupply() external view override returns (uint256) {
    return _totalSupply;
  }

  /**
    * @dev Returns the amount of tokens owned by `account`.
    */
  function balanceOf(address account) external view override returns (uint256) {
    return _balances[account];
  }

  /**
    * @dev Moves `amount` tokens from the caller's account to `recipient`.
    *
    * Returns a boolean value indicating whether the operation succeeded.
    *
    * Emits a {Transfer} event.
    */
  function transfer(address recipient, uint256 amount) external override returns (bool) {
    require(recipient != address(0), "ERC20: transfer to the zero address");
    require(amount <= _balances[msg.sender], "ERC20: transfer amount exceeds balance");

    _balances[msg.sender] = _balances[msg.sender].sub(amount);
    _balances[recipient] = _balances[recipient].add(amount);

    emit Transfer(msg.sender, recipient, amount);

    return true;
  }

  /**
    * @dev Returns the remaining number of tokens that `spender` will be
    * allowed to spend on behalf of `owner` through {transferFrom}. This is
    * zero by default.
    *
    * This value changes when {approve} or {transferFrom} are called.
    */
  function allowance(address owner, address spender) external view override returns (uint256) {
    return _allowances[owner][spender];
  }

  /**
    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
    *
    * Returns a boolean value indicating whether the operation succeeded.
    *
    * IMPORTANT: Beware that changing an allowance with this method brings the risk
    * that someone may use both the old and the new allowance by unfortunate
    * transaction ordering. One possible solution to mitigate this race
    * condition is to first reduce the spender's allowance to 0 and set the
    * desired value afterwards:
    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    *
    * Emits an {Approval} event.
    */
  function approve(address spender, uint256 amount) external override returns (bool) {
    require(spender != address(0), "ERC20: approve to the zero address");

    _allowances[msg.sender][spender] = amount;

    emit Approval(msg.sender, spender, amount);

    return true;
  }

  /**
    * @dev Moves `amount` tokens from `sender` to `recipient` using the
    * allowance mechanism. `amount` is then deducted from the caller's
    * allowance.
    *
    * Returns a boolean value indicating whether the operation succeeded.
    *
    * Emits a {Transfer} event.
    */
  function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
    require(sender != address(0), "ERC20: transfer from the zero address");
    require(recipient != address(0), "ERC20: transfer to the zero address");
    require(amount <= _balances[sender], "ERC20: transfer amount exceeds balance");
    require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");

    _balances[sender] = _balances[sender].sub(amount);
    _balances[recipient] = _balances[recipient].add(amount);
    _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount);

    emit Transfer(sender, recipient, amount);

    return true;
  }
}

contract EDFCrowdsale {
  EDFToken public token;
  uint256 public tokenPrice;
  uint256 public tokensSold;

  using SafeMath for uint256;

  event TokenPurchase(
    address indexed purchaser,
    uint256 value,
    uint256 amount
  );

  constructor(uint256 _totalSupply, uint256 _price) {
    token = new EDFToken(_totalSupply);
    tokenPrice = _price;
  }

  function buyTokens() public payable {
    uint256 weiAmount = msg.value;

    // calculate token amount being purchased
    uint256 tokens = weiAmount.div(tokenPrice);

    // update state
    tokensSold = tokensSold.add(tokens);

    // send tokens to buyer
    token.transfer(msg.sender, tokens);

    emit TokenPurchase(msg.sender, msg.value, tokens);
  }
}