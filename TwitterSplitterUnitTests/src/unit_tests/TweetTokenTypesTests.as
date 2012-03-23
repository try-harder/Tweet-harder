package unit_tests
{
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.runner.manipulation.NoTestsRemainException;
	import org.hamcrest.core.not;
	import org.hamcrest.object.sameInstance;
	
	import uk.org.tryharder.twittersplitter.TweetTokenTypes;

	[TestCase]
	/**
	 * Tests for the TweetTokenTypes enumeration.
	 */
	public class TweetTokenTypesTests
	{		
		[Test]
		public function testWordEnumContainsValue():void
		{
			assertNotNull(TweetTokenTypes.WORD);
		}
		
		[Test]
		public function testURLEnumContainsValue():void
		{
			assertNotNull(TweetTokenTypes.URL);
		}
		
		[Test]
		public function testTwitterNameEnumContainsValue():void
		{
			assertNotNull(TweetTokenTypes.TWITTER_NAME);
		}
		
		[Test]
		public function testTwitterNameAndWordEnumContainDifferentValues():void
		{
			assertThat(TweetTokenTypes.TWITTER_NAME, not(sameInstance(TweetTokenTypes.WORD)));
		}
		
		[Test]
		public function testURLAndWordEnumContainDifferentValues():void
		{
			assertThat(TweetTokenTypes.URL, not(sameInstance(TweetTokenTypes.WORD)));
		}
		
		[Test]
		public function testURLAndTwitterNameEnumContainDifferentValues():void
		{
			assertThat(TweetTokenTypes.URL, not(sameInstance(TweetTokenTypes.TWITTER_NAME)));
		}
		
		[Test(expects="Error")]
		public function testCannotAddNewEnumsAtRuntime():void
		{
			var test:TweetTokenTypes = new TweetTokenTypes("Test");
		}
	}
}