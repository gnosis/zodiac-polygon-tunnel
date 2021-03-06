// SPDX-License-Identifier: MIT
pragma solidity 0.7.3;

import "./lib/FxBaseChildTunnel.sol";
import "./TunnelEnd.sol";

contract ZodiacPolygonChildTunnel is FxBaseChildTunnel, TunnelEnd {
  constructor(address _fxChild) FxBaseChildTunnel(_fxChild) {}

  /// @dev Requests message relay to Root network
  /// @param target executor address on Root network
  /// @param data calldata passed to the executor on Root network
  /// @param gas gas limit used on Root Network for executing - 0xfffffff for unbound
  function sendMessage(
    address target,
    bytes memory data,
    uint256 gas
  ) public {
    bytes memory message = encodeIntoTunnel(target, data, gas);
    _sendMessageToRoot(message);
  }

  function _processMessageFromRoot(
    uint256,
    address sender,
    bytes memory message
  ) internal override validateSender(sender) {
    (
      bytes32 sourceChainId,
      address sourceChainSender,
      address target,
      bytes memory data,
      uint256 gas
    ) = decodeFromTunnel(message);
    forwardToTarget(sourceChainId, sourceChainSender, target, data, gas);
  }
}
