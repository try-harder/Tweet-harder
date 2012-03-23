package uk.org.tryharder.twittersplitter
{
	/**
	 * Generates a vector of TweetTokens from a tweet string
	 */
	public class TweetParser
	{
		/**
		 * Parses a tweet, generating a set of TweetTokens that represent its contents.
		 * 
		 * <p>For example, Hi @john, take a look at http://bbc.co.uk", would become
		 * [Hi] [tittername:john] [,] [take] [a] [look] [at] [url:http://bbc.co.uk]</p>
		 * 
		 * <p>The testParserDocumentationStringCorrectlyParses method in the test cases
		 * tests the above claim.</p>
		 */
		public static function parse(tweet:String):Vector.<TweetToken>
		{
			var regexp:RegExp = WORD_GRABBER_REGEX;
			var simpleResults:Array = tweet.match(regexp);
			var tokens:Vector.<TweetToken> = new Vector.<TweetToken>();
			
			for each (var word:String in simpleResults)
			{
				tokens = tokens.concat(extractTokensFromSimpleWord(word));
			}
			
			return tokens;
		}
		
		private static const WORD_GRABBER_REGEX:RegExp = /[^ \t\n\r]+/gm;
		private static const URL_EXTRACTOR_REGEX:RegExp = /(http|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\.\-,@?^=%&amp;:\/~\+#]*[\w\@?^=%&amp;\/~\+#])?|[\w_]+(\.[\w_]+)+\/([\w\.,@?^=%&amp;:\/~\+#]*[\w\-\@?^=%&amp;\/~\+#])?|\@[\w_]+/g;
		
		private static function extractTokensFromSimpleWord(word:String):Vector.<TweetToken>
		{
			var regexp:RegExp = URL_EXTRACTOR_REGEX;
			var results:Object;
			var matchedString:String = "";
			var lastIndex:int = 0;
			var tokens:Vector.<TweetToken> = new Vector.<TweetToken>();
			
			results = performNextRegexMatch(regexp, word, matchedString.length, lastIndex)
			while (results != null)
			{
				if (results.index != 0)
				{
					tokens.push(newWordToken(word, matchedString.length + lastIndex, results.index));
				}
				
				tokens.push(newURLOrTwitterNameToken(results[0]));
				matchedString = results[0];
				lastIndex = results.index;
				results = performNextRegexMatch(regexp, word, matchedString.length, lastIndex)
			}
			
			if (lastIndex + matchedString.length < word.length)
			{
				tokens.push(newWordToken(word, matchedString.length + lastIndex));
			}
			
			return tokens;
		}
		
		private static function performNextRegexMatch(regexp:RegExp, word:String, lastMatchLength:int, lastIndex:int):Object
		{
			var results:Object;
			regexp.lastIndex = lastMatchLength + lastIndex;
			results = regexp.exec(word);
			return results;
		}
		
		private static function newWordToken(word:String, startPoint:int, endPoint:int=int.MAX_VALUE):TweetToken
		{
			return new TweetToken(TweetTokenTypes.WORD, word.substring(startPoint, endPoint));
		}
		
		private static function newURLOrTwitterNameToken(string:String):TweetToken
		{
			if (string.substr(0, 1) == "@")
			{
				return new TweetToken(TweetTokenTypes.TWITTER_NAME, string.substr(1));
			}
			else
			{
				return new TweetToken(TweetTokenTypes.URL, string);
			}
		}
	}
}