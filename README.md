# DPlay Critic

## 계약 주소
- Mainnet: 0xa5e2c5Df97eBD0e45714430D122aDF3b9094AD3E
- Kovan: 0x6831b7a202Ec6F88100925867dCbcBAD10063Cc5
- Ropsten: 0xEDf96b606ae6ACEC685C0f789056cAFc6BE17E74
- Rinkeby: 0x6246B4e8129b24E96539EaAe816c932bC91D1037

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