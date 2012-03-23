package unit_tests
{
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	
	import uk.org.tryharder.twittersplitter.TweetParser;
	import uk.org.tryharder.twittersplitter.TweetToken;
	import uk.org.tryharder.twittersplitter.TweetTokenTypes;

	[TestCase]
	/**
	 * Tests for the TweetParser class.
	 */
	public class TweetParserTests
	{
		private const SINGLE_LONG_URL_TEST_STRING:String = "[https://www.google.co.uk/search?q=thai&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-GB:official&client=firefox-a.]";
		private const SINGLE_SHORT_URL_TEST_STRING:String = "(((((davidarno.org/)))))";
		private const DOUBLE_URL_TEST_STRING:String = "{([davidarno.org/]http://bbc.co.uk)}";
		private const TWITTERNAME_TEST_STRING:String = "@@someone,http://lala.lala(@another)";
		private const FULL_TEST_STRING:String = "aa []90 1 1@someone,1) lala";
		private const SINGLE_LONG_URL_MATCH:String = "https://www.google.co.uk/search?q=thai&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-GB:official&client=firefox-a";
		private const SINGLE_SHORT_URL_MATCH:String = "davidarno.org/";
		private const DOUBLE_URL_MATCH1:String = "{([";
		private const DOUBLE_URL_MATCH2:String = "davidarno.org/";
		private const DOUBLE_URL_MATCH3:String = "]";
		private const DOUBLE_URL_MATCH4:String = "http://bbc.co.uk";
		private const DOUBLE_URL_MATCH5:String = ")}";
		private const DOCUMENTATION_STRING:String = "Hi @john, take a look at http://bbc.co.uk";
		private const DOCUMENTATION_TOKENS:String = "[Hi] [titternamejohn] [,] [take] [a] [look] [at] [url:http://bbc.co.uk]";
		
		[Test]
		public function testParserDocumentationStringCorrectlyParses():void
		{
			var results:Vector.<TweetToken> = TweetParser.parse(DOCUMENTATION_STRING);
			assertEquals(DOCUMENTATION_TOKENS, results.join(" "));
		}
		
		[Test]
		public function testSimpleStringSplitByWhitespace():void
		{
			var results:Vector.<TweetToken> = TweetParser.parse("aa  bbb\tc\ndddd\r\ee\r\n\ffff");
			assertEquals(6, results.length);
		}

		[Test]
		public function testComplexStringSplitByWhitespace():void
		{
			var results:Vector.<TweetToken> = TweetParser.parse("%[ภาษาไทย] [http://lalala ] wooop$");
			assertEquals(4, results.length);
		}
		
		[Test]
		public function testFullTestStringHasSevenTokens():void
		{
			var results:Vector.<TweetToken> = TweetParser.parse(FULL_TEST_STRING);
			assertEquals(7, results.length);
		}
		
		[Test]
		public function testURLExtractedFromSingleLongURLStringAsSecondToken():void
		{
			var results:Vector.<TweetToken> = TweetParser.parse(SINGLE_LONG_URL_TEST_STRING);
			assertEquals(SINGLE_LONG_URL_MATCH, results[1].text);
		}
		
		[Test]
		public function testThreeTokensExtractedFromSingleLongURLString():void
		{
			var results:Vector.<TweetToken> = TweetParser.parse(SINGLE_LONG_URL_TEST_STRING);
			assertEquals(3, results.length);
		}
		
		[Test]
		public function testURLExtractedFromShortURLTestString():void
		{
			var results:Vector.<TweetToken> = TweetParser.parse(SINGLE_SHORT_URL_TEST_STRING);
			assertEquals(SINGLE_SHORT_URL_MATCH, results[1].text);
		}
		
		[Test]
		public function testFiveTokensFoundInTwoURLString():void
		{
			var extractedTerms:Vector.<TweetToken> = TweetParser.parse(DOUBLE_URL_TEST_STRING);
			assertEquals(5, extractedTerms.length);
		}
		
		[Test]
		public function testCorrectItem1FoundInTwoURLString():void
		{
			var extractedTerms:Vector.<TweetToken> = TweetParser.parse(DOUBLE_URL_TEST_STRING);
			assertEquals(DOUBLE_URL_MATCH1, extractedTerms[0].text);
		}
		
		[Test]
		public function testCorrectItem2FoundInTwoURLString():void
		{
			var extractedTerms:Vector.<TweetToken> = TweetParser.parse(DOUBLE_URL_TEST_STRING);
			assertEquals(DOUBLE_URL_MATCH2, extractedTerms[1].text);
		}
		
		[Test]
		public function testCorrectItem3FoundInTwoURLString():void
		{
			var extractedTerms:Vector.<TweetToken> = TweetParser.parse(DOUBLE_URL_TEST_STRING);
			assertEquals(DOUBLE_URL_MATCH3, extractedTerms[2].text);
		}
		
		[Test]
		public function testCorrectItem4FoundInTwoURLString():void
		{
			var extractedTerms:Vector.<TweetToken> = TweetParser.parse(DOUBLE_URL_TEST_STRING);
			assertEquals(DOUBLE_URL_MATCH4, extractedTerms[3].text);
		}
		
		[Test]
		public function testCorrectItem5FoundInTwoURLString():void
		{
			var extractedTerms:Vector.<TweetToken> = TweetParser.parse(DOUBLE_URL_TEST_STRING);
			assertEquals(DOUBLE_URL_MATCH5, extractedTerms[4].text);
		}
				
		[Test]
		public function testCorrectItem1TypeFoundInTwoURLString():void
		{
			var extractedTerms:Vector.<TweetToken> = TweetParser.parse(DOUBLE_URL_TEST_STRING);
			assertEquals(TweetTokenTypes.WORD, extractedTerms[0].type);
		}
		
		[Test]
		public function testCorrectItem2TypeFoundInTwoURLString():void
		{
			var extractedTerms:Vector.<TweetToken> = TweetParser.parse(DOUBLE_URL_TEST_STRING);
			assertEquals(TweetTokenTypes.URL, extractedTerms[1].type);
		}
		
		[Test]
		public function testCorrectItem3TypeFoundInTwoURLString():void
		{
			var extractedTerms:Vector.<TweetToken> = TweetParser.parse(DOUBLE_URL_TEST_STRING);
			assertEquals(TweetTokenTypes.WORD, extractedTerms[2].type);
		}
		
		[Test]
		public function testCorrectItem4TypeFoundInTwoURLString():void
		{
			var extractedTerms:Vector.<TweetToken> = TweetParser.parse(DOUBLE_URL_TEST_STRING);
			assertEquals(TweetTokenTypes.URL, extractedTerms[3].type);
		}
		
		[Test]
		public function testCorrectItem5TypeFoundInTwoURLString():void
		{
			var extractedTerms:Vector.<TweetToken> = TweetParser.parse(DOUBLE_URL_TEST_STRING);
			assertEquals(TweetTokenTypes.WORD, extractedTerms[4].type);
		}
		
		[Test]
		public function testSevenItemsFoundInTwitterNameString():void
		{
			var extractedTerms:Vector.<TweetToken> = TweetParser.parse(TWITTERNAME_TEST_STRING);
			assertEquals(7, extractedTerms.length);
		}
		
		[Test]
		public function testCorrectItem2TypeFoundInTwitterNameString():void
		{
			var extractedTerms:Vector.<TweetToken> = TweetParser.parse(TWITTERNAME_TEST_STRING);
			assertEquals(TweetTokenTypes.TWITTER_NAME, extractedTerms[1].type);
		}
		
		[Test]
		public function testCorrectItem6TypeFoundInTwitterNameString():void
		{
			var extractedTerms:Vector.<TweetToken> = TweetParser.parse(TWITTERNAME_TEST_STRING);
			assertEquals(TweetTokenTypes.TWITTER_NAME, extractedTerms[5].type);
		}
		
		[Test]
		public function testCorrectItem2FoundInTwitterNameString():void
		{
			var extractedTerms:Vector.<TweetToken> = TweetParser.parse(TWITTERNAME_TEST_STRING);
			assertEquals("someone", extractedTerms[1].text);
		}
	}
}