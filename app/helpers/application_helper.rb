module ApplicationHelper
    def admin_user?
        current_user&.is_admin?
    end
end
