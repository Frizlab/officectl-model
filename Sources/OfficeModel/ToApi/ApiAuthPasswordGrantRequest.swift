import Foundation

import Email



public struct ApiAuthPasswordGrantRequest : Codable {
	
	public var grantType: String = "password"
	
	public var username: TaggedID
	public var password: String
	
	/** If `nil`, **must** be passed via Basic Auth (recommended configuration). */
	public var clientId: String?
	public var clientSecret: String?
	
	/** A space-separated list of auth scopes. */
	public var scope: String
	
	public init(username: TaggedID, password: String, clientId: String? = nil, clientSecret: String? = nil, scope: Set<AuthScope>) {
		self.username = username
		self.password = password
		self.clientId = clientId
		self.clientSecret = clientSecret
		self.scope = scope.map{ $0.rawValue }.joined(separator: " ")
	}
	
	private enum CodingKeys : String, CodingKey {
		case grantType = "grant_type"
		
		case username
		case password
		
		case clientId = "client_id"
		case clientSecret = "client_secret"
		
		case scope
	}
	
}