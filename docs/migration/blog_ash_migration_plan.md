# Blog Domain Ash Migration Plan

## 📋 Current State Analysis

### Existing Structure
- **JsonCorp.Blog.Post**: Struct-based model with file-based content loading
- **JsonCorp.Blog.Comment**: Ecto schema with PostgreSQL storage
- **JsonCorp.Blog**: Main context module with caching and business logic
- **File-based Post System**: Posts stored as markdown files in `priv/posts/`
- **Caching Layer**: Using Nebulex for performance optimization

### Ash Readiness
- ✅ Ash already installed (`{:ash, "~> 3.0"}`)
- ✅ `blog_ash` directory structure created
- ❌ No Ash resources implemented yet
- ❌ No Ash domain configured

## 🚀 Migration Strategy

### Phase 1: Foundation Setup
**Goal**: Establish Ash domain and basic infrastructure

#### Tasks:
1. **Create Ash Domain**
   - [x] Generate `JsonCorp.Domain.Blog` domain module
   - [x] Configure Ash domain (added to config.exs)
   - [ ] Set up data layer configurations

2. **Data Layer Planning**
   - [ ] Custom FileSystem data layer for Posts
   - [ ] PostgreSQL data layer for Comments
   - [ ] Migration strategy for existing data

#### Deliverables:
- `lib/json_corp/domain/blog_ash.ex` ✅
- Domain registered in `config/config.exs` ✅
- Data layer configuration files

### Phase 2: Post Resource Migration
**Goal**: Convert Post struct to Ash resource with file-based storage

#### Tasks:
1. **Post Resource Creation**
   - [ ] Create `JsonCorp.Domain.BlogAsh.Resources.Post`
   - [ ] Map existing Post struct fields to Ash attributes
   - [ ] Implement custom file-based data layer

2. **Post Attributes**
   ```elixir
   attribute :id, :string, primary_key?: true
   attribute :title, :string, allow_nil?: false
   attribute :description, :string
   attribute :language, :string, allow_nil?: false
   attribute :category, :string, allow_nil?: false
   attribute :slug, :string, allow_nil?: false
   attribute :body, :string, allow_nil?: false
   attribute :date_created, :date, allow_nil?: false
   attribute :cover_url, :string
   attribute :tags, {:array, :string}, default: []
   attribute :aliases, {:array, :string}, default: []
   attribute :status, :atom, constraints: [one_of: [:published, :deleted]], default: :published
   ```

3. **Actions**
   - [ ] `:read` - List all posts
   - [ ] `:list_by_language` - Language-specific posts
   - [ ] `:fetch_by_slug` - Single post by slug
   - [ ] `:list_by_category` - Category filtering

4. **Calculations**
   - [ ] `full_id` - Normalized ID generation
   - [ ] `is_published` - Publication status check
   - [ ] `matching_aliases` - Alias matching logic

#### Deliverables:
- `lib/json_corp/domain/blog_ash/resources/post.ex`
- `lib/json_corp/domain/blog_ash/data_layers/file_system.ex`
- Test suite for Post resource

### Phase 3: Comment Resource Migration
**Goal**: Convert Comment Ecto schema to Ash resource

#### Tasks:
1. **Comment Resource Creation**
   - [ ] Create `JsonCorp.Domain.BlogAsh.Resources.Comment`
   - [ ] Migrate existing PostgreSQL schema
   - [ ] Implement CRUD actions

2. **Comment Attributes**
   ```elixir
   attribute :id, :uuid, primary_key?: true, default: &Ecto.UUID.generate/0
   attribute :post_slug, :string, allow_nil?: false
   attribute :session_id, :uuid, allow_nil?: false
   attribute :name, :string, allow_nil?: false
   attribute :email, :string, allow_nil?: false
   attribute :body, :string, allow_nil?: false
   attribute :confirmed_at, :utc_datetime_usec
   attribute :deleted_at, :utc_datetime_usec
   timestamps()
   ```

3. **Actions**
   - [ ] `:create` - Create new comment
   - [ ] `:read` - List comments
   - [ ] `:update` - Update comment
   - [ ] `:delete` - Soft delete comment
   - [ ] `:list_by_post_slug` - Post-specific comments

4. **Validations**
   - [ ] Name length (max 255)
   - [ ] Email length (max 255)
   - [ ] Body length (max 1000)
   - [ ] Email format validation

#### Deliverables:
- `lib/json_corp/domain/blog_ash/resources/comment.ex`
- Database migrations if needed
- Test suite for Comment resource

### Phase 4: Relationships & Aggregates
**Goal**: Establish resource relationships and computed fields

#### Tasks:
1. **Post-Comment Relationships**
   - [ ] `has_many :comments` on Post
   - [ ] `belongs_to :post` on Comment (virtual, slug-based)

2. **Aggregates**
   - [ ] `comment_count` on Post
   - [ ] `published_comment_count` on Post
   - [ ] `recent_comments` on Post

3. **Calculations**
   - [ ] `has_comments` boolean on Post
   - [ ] `comment_summary` on Post
   - [ ] `is_deletable` on Comment (by session/email)

#### Deliverables:
- Enhanced resource definitions
- Relationship configurations
- Aggregate and calculation implementations

### Phase 5: Authorization & Policies
**Goal**: Implement security and access control

#### Tasks:
1. **Post Policies**
   - [ ] Public read access for published posts
   - [ ] Admin access for all posts
   - [ ] Category-based access control

2. **Comment Policies**
   - [ ] Public read access for confirmed comments
   - [ ] Session-based create access
   - [ ] Email-based delete access
   - [ ] Admin full access

3. **Field Policies**
   - [ ] Hide email addresses from public
   - [ ] Show unconfirmed comments only to session owner

#### Deliverables:
- Policy modules for each resource
- Authorization rules documentation
- Security test suite

### Phase 6: API Compatibility Layer
**Goal**: Maintain backward compatibility with existing code

#### Tasks:
1. **Wrapper Functions**
   - [ ] `JsonCorp.Domain.Blog.list_posts_by_language/1`
   - [ ] `JsonCorp.Domain.Blog.fetch_post/2`
   - [ ] `JsonCorp.Domain.Blog.create_comment/1`
   - [ ] `JsonCorp.Domain.Blog.list_comments/1`
   - [ ] `JsonCorp.Domain.Blog.delete_comment/2`

2. **Gradual Migration**
   - [ ] Feature flags for Ash vs legacy
   - [ ] Performance comparison
   - [ ] Gradual rollout strategy

3. **Code Interface**
   - [ ] Define code interfaces on resources
   - [ ] Implement convenience functions
   - [ ] Error handling consistency

#### Deliverables:
- Compatibility layer module
- Migration guide
- Performance benchmarks

### Phase 7: Advanced Features
**Goal**: Leverage Ash's advanced capabilities

#### Tasks:
1. **Caching Integration**
   - [ ] Ash-native caching for frequently accessed posts
   - [ ] Cache invalidation strategies
   - [ ] Performance optimization

2. **Search & Filtering**
   - [ ] Full-text search on posts
   - [ ] Tag-based filtering
   - [ ] Date range queries
   - [ ] Language-aware search

3. **Batch Operations**
   - [ ] Bulk post imports
   - [ ] Batch comment moderation
   - [ ] Bulk data migrations

#### Deliverables:
- Advanced query implementations
- Search functionality
- Batch operation utilities

## 🔧 Implementation Order

1. **Week 1**: Phase 1 - Foundation Setup
2. **Week 2**: Phase 2 - Post Resource Migration
3. **Week 3**: Phase 3 - Comment Resource Migration
4. **Week 4**: Phase 4 - Relationships & Aggregates
5. **Week 5**: Phase 5 - Authorization & Policies
6. **Week 6**: Phase 6 - API Compatibility Layer
7. **Week 7**: Phase 7 - Advanced Features

## 📝 Success Criteria

- [ ] All existing functionality preserved
- [ ] Performance maintained or improved
- [ ] Clean, maintainable Ash resource definitions
- [ ] Comprehensive test coverage
- [ ] Documentation updated
- [ ] Zero-downtime migration
- [ ] Backward compatibility maintained

## 🚨 Risks & Mitigation

### Risk 1: File-based Post System Complexity
**Mitigation**: Implement custom data layer with comprehensive testing

### Risk 2: Performance Degradation
**Mitigation**: Benchmark each phase, optimize queries, maintain caching

### Risk 3: Breaking Changes
**Mitigation**: Maintain compatibility layer, gradual rollout, feature flags

### Risk 4: Data Loss
**Mitigation**: Comprehensive backups, migration scripts, rollback procedures

## 📚 References

- [Ash Framework Documentation](https://hexdocs.pm/ash)
- [Ash Resource Guide](https://hexdocs.pm/ash/resources.html)
- [Ash Policies Guide](https://hexdocs.pm/ash/policies.html)
- [Project Usage Rules](../rules/ash.md)

---

**Created**: 2024-01-XX
**Last Updated**: 2024-01-XX
**Status**: Phase 1 In Progress - Domain Created & Configured ✅
