# DPlayCritic

## 계약 주소
- Kovan: 0x9D787c1eD7e7b692D3a469670B75D3cfB5FbF352

## 테스트 여부
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `event Rate(uint indexed gameId, address indexed rater, uint rating, string review)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `event UpdateRating(uint indexed gameId, address indexed rater, uint rating, string review)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `event RemoveRating(uint indexed gameId, address indexed rater)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function ratingDecimals() external view returns (uint8)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function rate(uint gameId, uint rating, string calldata review) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function checkIsRater(address addr, uint gameId) external view returns (bool)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function getRating(address rater, uint gameId) external view returns (uint rating, string memory review)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function updateRating(uint gameId, uint rating, string calldata review) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function removeRating(uint gameId) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function getRatingCount(uint gameId) external view returns (uint)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function getOverallRating(uint gameId) external view returns (uint)`