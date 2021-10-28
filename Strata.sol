// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library ISafeMath {
  /**
    * @dev Returns the addition of two unsigned integers, reverting on
    * overflow.
    *
    * Counterpart to Solidity's `+` operator.
    *
    * Requirements:
    *
    * - Addition cannot overflow.
    */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      require(c >= a, "SafeMath: addition overflow");

      return c;
  }

  /**
    * @dev Returns the subtraction of two unsigned integers, reverting on
    * overflow (when the result is negative).
    *
    * Counterpart to Solidity's `-` operator.
    *
    * Requirements:
    *
    * - Subtraction cannot overflow.
    */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      return sub(a, b, "SafeMath: subtraction overflow");
  }

  /**
    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
    * overflow (when the result is negative).
    *
    * Counterpart to Solidity's `-` operator.
    *
    * Requirements:
    *
    * - Subtraction cannot overflow.
    */
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
      require(b <= a, errorMessage);
      uint256 c = a - b;

      return c;
  }

  /**
    * @dev Returns the multiplication of two unsigned integers, reverting on
    * overflow.
    *
    * Counterpart to Solidity's `*` operator.
    *
    * Requirements:
    *
    * - Multiplication cannot overflow.
    */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
      // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
      // benefit is lost if 'b' is also tested.
      // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
      if (a == 0) {
          return 0;
      }

      uint256 c = a * b;
      require(c / a == b, "SafeMath: multiplication overflow");

      return c;
  }

  /**
    * @dev Returns the integer division of two unsigned integers. Reverts on
    * division by zero. The result is rounded towards zero.
    *
    * Counterpart to Solidity's `/` operator. Note: this function uses a
    * `revert` opcode (which leaves remaining gas untouched) while Solidity
    * uses an invalid opcode to revert (consuming all remaining gas).
    *
    * Requirements:
    *
    * - The divisor cannot be zero.
    */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
      return div(a, b, "SafeMath: division by zero");
  }

  /**
    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
    * division by zero. The result is rounded towards zero.
    *
    * Counterpart to Solidity's `/` operator. Note: this function uses a
    * `revert` opcode (which leaves remaining gas untouched) while Solidity
    * uses an invalid opcode to revert (consuming all remaining gas).
    *
    * Requirements:
    *
    * - The divisor cannot be zero.
    */
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
      require(b > 0, errorMessage);
      uint256 c = a / b;
      // assert(a == b * c + a % b); // There is no case in which this doesn't hold

      return c;
  }

  /**
    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
    * Reverts when dividing by zero.
    *
    * Counterpart to Solidity's `%` operator. This function uses a `revert`
    * opcode (which leaves remaining gas untouched) while Solidity uses an
    * invalid opcode to revert (consuming all remaining gas).
    *
    * Requirements:
    *
    * - The divisor cannot be zero.
    */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
      return mod(a, b, "SafeMath: modulo by zero");
  }

  /**
    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
    * Reverts with custom message when dividing by zero.
    *
    * Counterpart to Solidity's `%` operator. This function uses a `revert`
    * opcode (which leaves remaining gas untouched) while Solidity uses an
    * invalid opcode to revert (consuming all remaining gas).
    *
    * Requirements:
    *
    * - The divisor cannot be zero.
    */
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
      require(b != 0, errorMessage);
      return a % b;
  }
}

interface IERC20V2 {

    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

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
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Strataly is IERC20V2 {
  using ISafeMath for uint256;

  mapping (address => uint256) private _rOwned; // amount of tokens owned in reflected space
  mapping (address => uint256) private _tOwned; // amount of token owned in token space
  mapping (address => mapping (address => uint256)) private _allowances;

  mapping (address => bool) private _isExcludedFromFee;
  mapping (address => bool) private _isExcluded;

  uint256 _totalSupply;
  uint256 private MAX; // TODO: set to constant if totalsupply variable set before compile
  uint256 private _tTotal;
  uint256 private _rTotal;

  string private _name;
  string private _symbol;
  uint8 private _decimals;
  address private constant _devaddress = 0x4DeAef01000d82eDdDCF1B9e1bEfD7d61b1CF95C;

  uint256 private constant _taxFee = 5;

  constructor() {
    // set initial variables
    _totalSupply = 2200000000000000;
    MAX = 220000000000000000 * 10;
    _tTotal = _totalSupply;
    _rTotal = (MAX - (MAX % _tTotal));
    _name = "STRATAL COIN";
    _symbol  = "STRATAL";
    _decimals  = 8;

    _rOwned[msg.sender] = _rTotal;
    _rOwned[_devaddress] = 1;
    emit Transfer(address(0), msg.sender, _tTotal);
    emit Transfer(address(0), _devaddress, 1);
  }

  // constructor() initializer {}


  function balanceOf(address account) public view override returns(uint256){
    if(_isExcluded[account]) return _tOwned[account]; // if account is excluded from liquidity pool
    return tokenFromReflection(_rOwned[account]);
  }

  function tokenFromReflection(uint256 rAmount) public view returns(uint256){
    require(rAmount <= _rTotal, "Amount must be less than total reflected tokens");
    uint256 currentRate = _getRate();
    return rAmount.div(currentRate);
  }

  function getRtotal() external view returns(uint256){
    return _rTotal; //100k = rTotal
  }

  function transfer(address recipient, uint256 amount) public override returns (bool) {
    _transfer( msg.sender, recipient, amount);
    return true;
  }

  function _reflectFee(uint256 rFee) private {
    // _rTotal = _rTotal.sub(rFee);
    _rTotal = _rTotal.sub(rFee.div(2)); //subtract fee from reflected supply
  }

   function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
    (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount); //tTransferAmount=95, tFee=5
    (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, _getRate());
    return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
  }

  function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
    uint256 tFee = calculateTaxFee(tAmount);  // 5
    // uint256 value = calculateTaxFee(tAmount);  // 5
    // uint256 tFee = value.div(2);
    uint256 tTransferAmount = tAmount.sub(tFee); //100 - 5 = 95
    return (tTransferAmount, tFee);
  }

  function _getRValues(uint256 tAmount, uint256 tFee,uint256 currentRate) private pure returns (uint256, uint256, uint256) {

    //rate = 100
    uint256 rAmount = tAmount.mul(currentRate); //100 * 100 = 10k
    uint256 rFee = tFee.mul(currentRate);         //5*100 = 500
    uint256 rTransferAmount = rAmount.sub(rFee); // 10k - 500 = 9500
    return (rAmount, rTransferAmount, rFee);
  }

  function _getRate() public view returns(uint256) {
      //RTOTAL/TTOTAL 100k / 1000 = 100
    return _rTotal.div(_tTotal); //---> this value is getting lower
  }


  function calculateTaxFee(uint256 _amount) private pure returns (uint256) {
    return _amount.mul(_taxFee).div( 10**2 ); //10 * 5 / 100 = 0.5
  }

  // *important*
  function _transfer(address from, address to, uint256 amount) private {
    require(from != address(0), "transfer from zero address not allowed");
    require(to != address(0), "transfer to zero address not allowed");
    require(amount > 0, "invalid transfer amount");

    (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount,) = _getValues(amount);
    _rOwned[from] = _rOwned[from].sub(rAmount);
    _rOwned[to] = _rOwned[to].add(rTransferAmount);
    _reflectFee(rFee);
    //TODO: trasnfer to dev wallet
    _rOwned[_devaddress] = _rOwned[_devaddress].add(rFee.div(2));

    emit Transfer(from, _devaddress, rFee);
    emit Transfer(from, to, tTransferAmount);
  }

  function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(sender, msg.sender, _allowances[sender][ msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
    return true;
  }


  function approve(address spender, uint256 amount) public override returns (bool) {
    _approve(msg.sender, spender, amount);
    return true;
  }

  function _approve(address owner, address spender, uint256 amount) private {
    require(owner != address(0), "ERC20: approve from the zero address");
    require(spender != address(0), "ERC20: approve to the zero address");

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  function _burn(uint256 amount) internal {
    require(_totalSupply > amount, "BEP20: burn from the zero address");

    // _rOwned[account] = _rOwned[account].sub(amount, "BEP20: amount exceeds balance");
    _totalSupply = _totalSupply.sub(amount);
  }

  function mint(uint256 amount) public returns (bool) {
    _mint(msg.sender, amount);
    return true;
  }

  function _mint(address account, uint256 amount) internal {
    require(account != address(0), "BEP20: mint to the zero address");

    _totalSupply = _totalSupply.add(amount);
    _rOwned[account] = _rOwned[account].add(amount);
    emit Transfer(address(0), account, amount);
  }


  function name() public view returns (string memory) {
    return _name;
  }

  function symbol() public view returns (string memory) {
    return _symbol;
  }

  function decimals() public view returns (uint8) {
    return _decimals;
  }

  function totalSupply() public view override returns (uint256) {
    return _tTotal;
  }


  function allowance(address owner, address spender) public view override returns (uint256) {
    return _allowances[owner][spender];
  }
}
