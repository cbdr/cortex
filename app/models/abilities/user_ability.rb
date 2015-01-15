module Abilities
  class UserAbility
    class << self
      def allowed(user, subject)
        abilities = []

        if subject.is_a? Class
          if subject == User;            abilities += user_class_abilities(user)
          elsif subject == Tenant;       abilities += tenant_class_abilities(user)
          elsif subject == Post;         abilities += post_class_abilities(user)
          elsif subject == Media;        abilities += media_class_abilities(user)
          elsif subject == Category;     abilities += category_class_abilities(user)
          elsif subject == Localization; abilities += localization_class_abilities(user)
          elsif subject == Locale;       abilities += locale_class_abilities(user)
          end
        else
          if subject.kind_of? User;            abilities += user_abilities(user, subject)
          elsif subject.kind_of? Tenant;       abilities += tenant_abilities(user, subject)
          elsif subject.kind_of? Post;         abilities += post_abilities(user, subject)
          elsif subject.kind_of? Media;        abilities += media_abilities(user, subject)
          elsif subject.kind_of? Localization; abilities += localization_abilities(user, subject)
          elsif subject.kind_of? Locale;       abilities += locale_abilities(user, subject)
          end
        end

        abilities
      end

      private

      def user_abilities(user, user_subject)
        abilities = []

        # Users can view themselves, admins can view all
        if user_subject.id == user.id || user.is_admin?
          abilities += [:view, :update]
        end

        abilities
      end

      def user_class_abilities(user)
        if user.is_admin?
          [:view, :create]
        else
          []
        end
      end

      def tenant_abilities(user, tenant)
        if user.is_admin?
          [:view, :update, :delete]
        else
          []
        end
      end

      def tenant_class_abilities(user)
        if user.is_admin?
          [:view, :create]
        else
          []
        end
      end

      def post_abilities(user, post)
        if user.is_admin?
          [:view, :update, :delete]
        elsif post.published?
          [:view]
        else
          []
        end
      end

      def post_class_abilities(user)
        if user.is_admin?
          [:view, :create]
        else
          []
        end
      end

      def media_abilities(user, media)
        if user.is_admin?



       [:view, :update, :delete]
        else
          []
        end
      end

      def media_class_abilities(user)
        if user.is_admin?
          [:view, :create]
        else
          []
        end
      end

      def category_class_abilities(user)
        if user.is_admin?
          [:view]
        else
          []
        end
      end

      def localization_abilities(user, localization)
        if user.is_admin?
          [:view, :update, :delete]
        else
          []
        end
      end

      def localization_class_abilities(user)
        if user.is_admin?
          [:view, :create]
        else
          []
        end
      end

      def locale_abilities(user, locale)
        if user.is_admin?
          [:view, :update, :delete]
        else
          []
        end
      end

      def locale_class_abilities(user)
        if user.is_admin?
          [:view, :create]
        else
          []
        end
      end
    end
  end
end
