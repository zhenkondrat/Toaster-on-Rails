class CreateMemberships < ActiveRecord::Migration
  def up
    create_table :memberships do |t|
      t.integer :group_id
      t.integer :member_id
      t.string  :member_type, default: :student
      t.timestamps null: false
    end

    helper = InsertHelper.new(klass: Membership)
    rows =
      Group.all.map do |group|
        group.users.ids.map{|user_id| [group.id, user_id] }
      end
    helper.insert!(rows: rows.flatten(1))

    drop_join_table :groups, :users
  end

  def down
    create_join_table :groups, :users

    helper = InsertHelper.new(table_name: :groups_users)
    rows =
      Membership.where(member_type: :student).map do |membership|
        [membership.group_id, membership.member_id]
      end
    helper.insert!(cols: [:group_id, :user_id], rows: rows)

    drop_table :memberships
  end
end
