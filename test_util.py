import unittest

import util


class TestUtil(unittest.TestCase):
    def test_cut_string(self):
        self.assertEqual(util.cut_string('abcdef', 7), 'abcdef')
        self.assertEqual(util.cut_string('abcdef', 6), 'abcdef')
        self.assertEqual(util.cut_string('abcdef', 5), 'ab...')
        self.assertEqual(util.cut_string('abcdef', 4), 'a...')
        self.assertEqual(util.cut_string('abcdef', 3), '...')
        self.assertEqual(util.cut_string('あいうえお', 10), 'あいうえお')
        self.assertEqual(util.cut_string('あいうえお', 9), 'あいう...')
        self.assertEqual(util.cut_string('あいうえお', 8), 'あい...')
        self.assertEqual(util.cut_string('あいうえお', 7), 'あい...')
        self.assertEqual(util.cut_string('あいうえお', 6), 'あ...')
        self.assertEqual(util.cut_string('あいうえお', 5), 'あ...')
        self.assertEqual(util.cut_string('あいうえお', 4), '...')
        self.assertEqual(util.cut_string('あいうえお', 3), '...')


if __name__ == '__main__':
    unittest.main()
