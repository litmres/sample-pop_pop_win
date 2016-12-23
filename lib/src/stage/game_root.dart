// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
library pop_pop_win.stage.game_root;

import 'package:stagexl/stagexl.dart';

import '../audio.dart' as game_audio;
import '../game.dart';
import '../game_manager.dart';
import 'game_element.dart';

class GameRoot extends GameManager {
  final Stage stage;
  final ResourceManager resourceManager;
  GameElement _gameElement;

  GameRoot(
      int width, int height, int bombCount, this.stage, this.resourceManager)
      : super(width, height, bombCount) {
    resourceManager.getTextureAtlas('opaque');
    resourceManager.getTextureAtlas('static');

    _gameElement = new GameElement(this)..alpha = 0;

    stage
      ..addChild(_gameElement)
      ..juggler.addTween(_gameElement, .5).animate.alpha.to(1);
  }

  @override
  void onGameStateChanged(GameState newState) {
    if (newState == GameState.won) {
      for (var se in _gameElement.boardElement.squares) {
        se.updateState();
      }
      if (game.duration.inMilliseconds < _gameElement.scoreElement.bestTime ||
          _gameElement.scoreElement.bestTime == 0) {
        _gameElement.scoreElement.bestTime = game.duration.inMilliseconds;
      }
      game_audio.win();
    }
  }

  @override
  void newGame() {
    super.newGame();
    if (_gameElement != null) {
      for (var se in _gameElement.boardElement.squares) {
        se.updateState();
      }
    }
  }
}
