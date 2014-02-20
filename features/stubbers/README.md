Stubbers are used to stub out a provider during a consumer test.

Stubbers must allow interactions to be stubbed and cleared. They are also notified of when the Shokkenki session starts and closes to enable them to perform any setup or cleanup required.

Stubbers can also be queried for unmatched requests (requests that were received by the stubber that did not match any interactions) or unused interactions (interactions that were stubbed but never matched any requests).