pragma solidity ^0.4.19;

import "./ownable.sol";
import "./safemath.sol";

contract KunFactory is Ownable {

  using SafeMath for uint256;

  // struct Skill {
  //   // 7个等级、5个类别确定技能点
  //   // uint16[7][5] skills;
  //   // = [
  //   // /*          1  2   3   4   5 */
  //   // /* 尸鲲 */ 50,100,150,200,250,
  //   // /* 祖坤 */ 20,100,210,350,520,
  //   // /* 岩鲲 */ 220,230,240,250,260,
  //   // /* 饕餮 */ 120,150,190,240,300,
  //   // /* 天凤 */ 30,170,240,230,700,
  //   // /* 骨蛟 */ 120,150,190,240,300,
  //   // /* 姜鲲 */ 60,120,240,480,960
  //   // ];
  // }

  /* id, 类别, 等级, skill */
  event NewKun(uint kunId, uint8 _type, uint32 level, uint32 skill);

  uint kunTypeMod = 7;
  uint kunLevelMod = 5;

  struct Kun {
    // uint kunId; // id
    uint8 _type; // 类别
    uint32 level; // 等级
    uint32 readyTime; // 下次吞噬准备时间
    uint16 winCount; // 成功吞噬次数
  }

  Kun[] public kuns;

  mapping (uint => address) public kunToOwner; // 鲲id和所有者间映射
  mapping (address => uint) ownerKunCount; // 所有者和拥有鲲数目间映射

  function _createKun(uint8 _type, uint32 level, uint32 skill) internal {
    // uint cooldownTime = 5 - (0.5*_type + 0.1*level); // 最短1分钟
    uint cooldownTime = 0;
    uint32 readyTime = uint32(now + cooldownTime); 
    // uint32 skill = skills[_type][level];
    uint id = kuns.push(Kun(_type, level, readyTime, 0)) - 1;
    kunToOwner[id] = msg.sender;
    ownerKunCount[msg.sender] = ownerKunCount[msg.sender].add(1);
    NewKun(id, _type, level, skill);
  }

  // function _generateRandomKun(string _str) private view returns (uint, uint) {
  //   // 初始抽卡
  //   // uint rand = uint(keccak256(_str));
  //   // uint rand = uint(_str);
  //   return (rand % kunTypeMod, rand % kunLevelMod);
  // }

  // function createRandomKun(string _str) public {
  //   // _str: 符咒...
  //   uint kunType;
  //   uint kunLevel;
  //   require(ownerKunCount[msg.sender] <= 3);
  //   (kunType, kunLevel) = _generateRandomKun(_str);
  // }

  function initKun(uint8 _type, uint32 level, uint32 skill) public {
    // 初始抽3张
    require(ownerKunCount[msg.sender] <= 3);
    _createKun(_type, level, skill);
  }
}

