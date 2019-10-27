require 'json'

module TrelloBackupRenderer
  module Parsing
    include Models

    def parse_card_json(card_json)
      Card.new(
        closed: card_json['closed'],
        name: card_json['name'],
        pos: card_json['pos']
      )
    end

    def parse_list_json(list_json, cards_json)
      List.new(
        cards: (cards_json.select {|card_json| card_json['idList'] == list_json['id']}).map { |card_json| parse_card_json(card_json) },
        closed: list_json['closed'],
        name: list_json['name'],
        pos: list_json['pos']
      )
    end

    def parse_board_json(board_json)
      cards_json = board_json['cards'] || []
      Board.new(
        lists: (board_json['lists'] || []).map { |list_json| parse_list_json(list_json, cards_json) }
      )
    end

    def load_board_dir(dir)
      raise Error, "Not a directory: #{dir}" unless File.directory?(dir)
      board_file_paths = Dir.glob(File.join(dir, '*_full.json')).to_a
      raise Error, "Expected one <board_name>_full.json file in: #{dir}" unless board_file_paths.count == 1
      board_json = JSON.parse(File.read(board_file_paths.first))
      parse_board_json(board_json)
    end
  end
end