pragma solidity ^0.5.9;

import "./DPlayCriticInterface.sol";
import "./DPlayCoinInterface.sol";
import "./DPlayStoreInterface.sol";
import "./Util/NetworkChecker.sol";
import "./Util/SafeMath.sol";

contract DPlayCritic is DPlayCriticInterface, NetworkChecker {
	using SafeMath for uint;
	
	uint8 constant private RATING_DECIMALS = 18;
	
	mapping(address => uint[]) private raterToGameIds;
	mapping(uint => Rating[]) private gameIdToRatings;
	
	DPlayCoinInterface private dplayCoin;
	DPlayStoreInterface private dplayStore;
	
	constructor() NetworkChecker() public {
		
		// DPlay 관련 스마트 계약들을 불러옵니다.
		if (network == Network.Mainnet) {
			dplayCoin = DPlayCoinInterface(0x92c5387aCE61F5c505BF2c2D4c84120F0A813d4B);
			dplayStore = DPlayStoreInterface(0x6AbD63da2f98dD181B30eedd0377e74DF503e55B);
		} else if (network == Network.Kovan) {
			dplayCoin = DPlayCoinInterface(0xb53A87bC4E5443a3e7BdaB0FAb53fd5661573036);
			dplayStore = DPlayStoreInterface(0x8C2E9938DBd456ac12329fC9cC566bCF0D6269B8);
		} else if (network == Network.Ropsten) {
			dplayCoin = DPlayCoinInterface(0x1ab85da3f07D66C4465929b8B8C1C8C47b531d5a);
			dplayStore = DPlayStoreInterface(0x81Eba90B7765fda1AF6aEA03db2491cff4a243Cf);
		} else if (network == Network.Rinkeby) {
			dplayCoin = DPlayCoinInterface(0xBDC07353d7D0CBeD081cA08933a1ACA0d9c82a38);
			dplayStore = DPlayStoreInterface(0x01DA6dAdCE4662ecB32A544D8dD6f2796Ae986a6);
		} else {
			revert();
		}
	}
	
	function ratingDecimals() external view returns (uint8) {
		return RATING_DECIMALS;
	}
	
	// Rates the game.
	// 게임을 평가합니다.
	function rate(uint gameId, uint rating, string calldata review) external {
		
		(
			address gamePublisher,
			bool isGameReleased,
			uint gamePrice,
			,
			,
			,
			,
			,
			
		) = dplayStore.getGameInfo(gameId);
		
		// The game info must be normal.
		// 정상적인 게임 정보여야 합니다.
		require(gamePublisher != address(0x0));
		
		// 출시된 게임이어야 합니다.
		require(isGameReleased == true);
		
		// Paid games can only be rated buy their buyers.
		// 유료 게임은 구매자만 평가할 수 있습니다.
		require(gamePrice == 0 || dplayStore.checkIsBuyer(msg.sender, gameId) == true);
		
		// The sender can rate the game only once.
		// 이미 평가한 경우에는 재평가할 수 없습니다.
		require(checkIsRater(msg.sender, gameId) != true);
		
		// The rating must be 10 or lower.
		// 점수는 10점 이하여야 합니다.
		require(rating <= 10 * 10 ** uint(RATING_DECIMALS));
		
		// Registers the message sender as a rater.
		// 평가자로 등록합니다.
		raterToGameIds[msg.sender].push(gameId);
		
		// Registers the rating.
		// 평가를 등록합니다.
		gameIdToRatings[gameId].push(Rating({
			rater : msg.sender,
			rating : rating,
			review : review
		}));
		
		emit Rate(gameId, msg.sender, rating, review);
	}
	
	// Checks if the given address is the rater's address.
	// 특정 주소가 평가자인지 확인합니다.
	function checkIsRater(address addr, uint gameId) public view returns (bool) {
		
		uint[] memory gameIds = raterToGameIds[addr];
		for (uint i = 0; i < gameIds.length; i += 1) {
			if (gameIds[i] == gameId) {
				return true;
			}
		}
		
		return false;
	}
	
	// Returns the rating info of the given rater.
	// 특정 평가자가 내린 평가 정보를 반환합니다.
	function getRating(address rater, uint gameId) external view returns (uint rating, string memory review) {
		
		Rating[] memory ratings = gameIdToRatings[gameId];
		for (uint i = 0; i < ratings.length; i += 1) {
			
			// Finds the rating rated by the rater.
			// 특정 평가자가 내린 평가인 경우
			if (ratings[i].rater == rater) {
				return (
					ratings[i].rating,
					ratings[i].review
				);
			}
		}
	}
	
	// Gets the game IDs rated by the given rater.
	// 특정 평가자가 평가한 게임 ID들을 가져옵니다.
	function getRatedGameIds(address rater) external view returns (uint[] memory) {
		return raterToGameIds[rater];
	}
	
	// Updates a rating.
	// 평가를 수정합니다.
	function updateRating(uint gameId, uint rating, string calldata review) external {
		
		Rating[] storage ratings = gameIdToRatings[gameId];
		for (uint i = 0; i < ratings.length; i += 1) {
			
			// The sender must be the rater.
			// 평가자인 경우에만
			if (ratings[i].rater == msg.sender) {
				
				ratings[i].rating = rating;
				ratings[i].review = review;
				
				emit UpdateRating(gameId, msg.sender, rating, review);
				return;
			}
		}
	}
	
	// Returns the number of ratings of a game.
	// 게임의 평가 수를 반환합니다.
	function getRatingCount(uint gameId) external view returns (uint) {
		return gameIdToRatings[gameId].length;
	}
	
	// Returns the overall rating of a game.
	// Overall rating = (The sum of all weighted ratings : Each rater's DC Power * Each rater's rating) / Sum of each rater's DC Power
	// 게임의 종합 평가 점수를 반환합니다.
	// 종합 평가 점수 = (모든 평가의 합: 평가자 A의 DC Power * 평가자 A의 평가 점수) / 모든 평가자의 DC Power
	function getOverallRating(uint gameId) external view returns (uint) {
		
		uint totalPower = 0;
		uint totalRating = 0;
		
		Rating[] memory ratings = gameIdToRatings[gameId];
		for (uint i = 0; i < ratings.length; i += 1) {
			if (ratings[i].rater != address(0x0)) {
				
				uint power = dplayCoin.getPower(ratings[i].rater);
				
				totalPower = totalPower.add(power);
				totalRating = totalRating.add(power.mul(ratings[i].rating));
			}
		}
		
		return totalPower == 0 ? 0 : totalRating.div(totalPower);
	}
}
