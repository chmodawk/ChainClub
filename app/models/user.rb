class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :groups
  has_many :group_relationships
  has_many :participated_groups, :through => :group_relationships, :source => :group  
  has_many :posts
  has_many :comments #小组文章post的评论
  has_many :official_articles
  has_many :article_comments  #官方文章official article的评论
  has_many :answers, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :meetup_groups
  has_one :profile, dependent: :destroy
  has_many :jobs
  has_many :courses
  has_many :projects
  has_many :official_articles
  has_many :post_comments, dependent: :destroy
   
  
  has_paper_trail
  
  mount_uploader :avatar, UserAvatarUploader

  accepts_nested_attributes_for :profile

  ROLES = ["super_admin","admin", "editor"]

  def is_super_admin?
    self.role == "super_admin"
  end

  def is_admin?
    ["super_admin", "admin"].include?(self.role) # 如果是 super_admin 的话，当然也有 admin 的权限
  end

  def is_editor?
    ["super_admin","admin", "editor"].include?(self.role)
  end
  
  def display_name
    if self.username.present?
      self.username
    else
      self.email.split("@").first
    end
  end
  
  def is_member_of?(group)
    participated_groups.include?(group)
  end  
  
  def join!(group)
    participated_groups << group
  end

  def quit!(group)
    participated_groups.delete(group)
  end

  # ---收藏官方文章功能三方关系代码块---
  has_many :official_article_relationships
  has_many :liked_official_articles, :through => :official_article_relationships, :source => :official_article
  
  def is_fan_of?(official_article)
    liked_official_articles.include?(official_article)
  end
  
  def like_official_article!(official_article)
    liked_official_articles << official_article
  end

  def unlike_official_article!(official_article)
    liked_official_articles.delete(official_article)
  end

  # ---收藏社区文章功能三方关系代码块---
  has_many :topic_relationships
  has_many :liked_topics, :through => :topic_relationships, :source => :topic
  
  def is_fan_of?(topic)
    liked_topics.include?(topic)
  end
  
  def like_topic!(topic)
    liked_topics << topic
  end

  def unlike_topic!(topic)
    liked_topics.delete(topic)
  end
  
  
end
