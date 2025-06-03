import Foundation

/// API Response wrapper for consistent response structure
public struct APIResponse<T: Decodable>: Decodable {
    /// HTTP status code of the response
    public let status: Int
    /// Success indicator
    public let success: Bool
    /// Optional message describing the response
    public let message: String?
    /// The actual response data
    public let data: T?
    /// API path that generated this response
    public let path: String
    /// When the response was generated (ISO8601 format)
    public let timestamp: String
    /// Optional metadata about the response
    public let meta: ResponseMeta?

    public init(
        status: Int,
        success: Bool,
        message: String?,
        data: T?,
        path: String,
        timestamp: String,
        meta: ResponseMeta?
    ) {
        self.status = status
        self.success = success
        self.message = message
        self.data = data
        self.path = path
        self.timestamp = timestamp
        self.meta = meta
    }
}

/// Response metadata for additional information
public struct ResponseMeta: Decodable {
    /// Pagination information
    public let pagination: PaginationMeta?
    /// Total count of items (for list responses)
    public let totalCount: Int?
    /// Processing time in milliseconds
    public let processingTime: Double?
    /// API version
    public let version: String?

    public init(
        pagination: PaginationMeta?,
        totalCount: Int?,
        processingTime: Double?,
        version: String?
    ) {
        self.pagination = pagination
        self.totalCount = totalCount
        self.processingTime = processingTime
        self.version = version
    }
}

/// Pagination metadata
public struct PaginationMeta: Decodable {
    /// Current page number
    public let currentPage: Int
    /// Number of items per page
    public let perPage: Int
    /// Total number of pages
    public let totalPages: Int
    /// Total number of items
    public let totalItems: Int
    /// Whether there's a next page
    public let hasNext: Bool
    /// Whether there's a previous page
    public let hasPrevious: Bool

    public init(
        currentPage: Int,
        perPage: Int,
        totalPages: Int,
        totalItems: Int,
        hasNext: Bool,
        hasPrevious: Bool
    ) {
        self.currentPage = currentPage
        self.perPage = perPage
        self.totalPages = totalPages
        self.totalItems = totalItems
        self.hasNext = hasNext
        self.hasPrevious = hasPrevious
    }
}

/// Empty data structure for responses without data
public struct EmptyData: Decodable {
    public init() {}
}