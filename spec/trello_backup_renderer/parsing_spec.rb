RSpec.describe TrelloBackupRenderer::Parsing do
  describe '.load_attachment_paths' do
    it 'correctly loads paths for test board' do
      expect(TrelloBackupRenderer.load_attachment_paths(TEST_BOARD_DIR)).to eq(
        'id7' => "#{TEST_BOARD_DIR}/#{TEST_COVER_RELATIVE_PATH}"
      )
    end
  end

  describe '.relativize_attachment_paths' do
    it 'removes base directory' do
      paths = { 'id0' => "#{TEST_BOARD_DIR}/foo/bar" }
      expect(TrelloBackupRenderer.relativize_attachment_paths(paths, TEST_BOARD_DIR)).to eq(
        'id0' => 'foo/bar'
      )
    end
  end

  describe '.load_board_dir' do
    it 'correctly loads test board' do
      board = TrelloBackupRenderer.load_board_dir(TEST_BOARD_DIR)
      
      lists = board.lists
      expect(lists.count).to eq(3)
      
      list0 = lists[0]
      expect(list0.closed).to be(false)
      expect(list0.name).to eq('First List')
      
      list1 = lists[1]
      expect(list1.closed).to be(false)
      expect(list1.name).to eq('Empty List')

      list2 = lists[2]
      expect(list2.closed).to be(false)
      expect(list2.name).to eq('Third List')

      l0cards = lists[0].cards
      expect(l0cards.count).to eq(2)

      l1cards = lists[1].cards
      expect(l1cards.count).to eq(0)

      l2cards = lists[2].cards
      expect(l2cards.count).to eq(1)

      card0 = l0cards[0]
      expect(card0.closed).to be(false)
      expect(card0.cover_attachment).to be_nil
      expect(card0.name).to eq('Simple Card')

      card1 = l0cards[1]
      expect(card1.closed).to be(false)
      expect(card1.cover_attachment).to_not be_nil
      expect(card1.cover_attachment.path).to eq(TEST_COVER_RELATIVE_PATH)
      expect(card1.desc).to eq('This card has a description.')
      expect(card1.name).to eq('Card with All Supported Features')

      card2 = l2cards[0]
      expect(card2.closed).to be(false)
      expect(card0.cover_attachment).to be_nil
      expect(card2.name).to eq('Labeled Card')

      c1labels = card1.labels
      expect(c1labels.count).to eq(1)
      expect(c1labels[0].color).to eq('yellow')
      expect(c1labels[0].name).to eq('Yellow Label')

      c2labels = card2.labels
      expect(c2labels.count).to eq(1)
      expect(c2labels[0].color).to eq('green')
      expect(c2labels[0].name).to eq('Green Label')
    end
  end
end