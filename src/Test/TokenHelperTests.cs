using Microsoft.VisualStudio.TestTools.UnitTesting;
using Server.Source.Helper;
using Server.Source.NetCoreServer;
using System;
using System.Text;

namespace UnitTests
{
    [TestClass]
    public class TokenHelperTests
    {
        [TestMethod]
        public void TestCreateToken()
        {
            var sessionId = "abc123";
            var token = TokenHelper.CreateToken(sessionId, 10);

            Assert.IsFalse(string.IsNullOrEmpty(token));

            // Token phải decode được
            var raw = Encoding.UTF8.GetString(Convert.FromBase64String(token));
            Assert.IsTrue(raw.StartsWith(sessionId + ":"));
        }

        [TestMethod]
        public void TestTryParseToken_Valid()
        {
            var sessionId = "testSession";
            var token = TokenHelper.CreateToken(sessionId, 1); // 1 phút hợp lệ

            var result = TokenHelper.TryParseToken(token, out var parsedSessionId);

            Assert.IsTrue(result);
            Assert.AreEqual(sessionId, parsedSessionId);
        }

        [TestMethod]
        public void TestTryParseToken_Expired()
        {
            var sessionId = "expiredSession";
            var token = TokenHelper.CreateToken(sessionId, -1); // đã hết hạn

            var result = TokenHelper.TryParseToken(token, out var parsedSessionId);

            Assert.IsFalse(result);
        }

        [TestMethod]
        public void TestTryParseToken_InvalidFormat()
        {
            var invalidToken = Convert.ToBase64String(Encoding.UTF8.GetBytes("invalid-format"));

            var result = TokenHelper.TryParseToken(invalidToken, out var parsedSessionId);

            Assert.IsFalse(result);
        }

        [TestMethod]
        public void TestGetToken()
        {
            var request = new MockHttpRequest();
            var expectedToken = "sample-token-123";

            request.SetHeader("X_Token_Authorization", expectedToken);

            var token = TokenHelper.GetToken(request);

            Assert.AreEqual(expectedToken, token);
        }

        [TestMethod]
        public void TestGetToken_NotFound()
        {
            var request = new MockHttpRequest(); // không set token

            var token = TokenHelper.GetToken(request);

            Assert.IsNull(token);
        }
    }

    // 🧪 Mock class đơn giản thay cho HttpRequest thật
    public class MockHttpRequest : HttpRequest
    {
        private List<(string, string)> _headers = new();

        public void SetHeader(string key, string value)
        {
            _headers.Add((key, value));
        }

        public string GetHeader(string key)
        {
            return _headers.FirstOrDefault(h => h.Item1 == key).Item2;
        }
    }
}
