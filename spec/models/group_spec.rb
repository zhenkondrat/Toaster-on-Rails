require 'spec_helper'

describe Group do

  let(:group) { create(:group) }

  describe 'validates' do
    it { expect(group).to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { expect(group).to have_many(:memberships) }
    it { expect(group).to have_many(:owners).through(:memberships) }
    it { expect(group).to have_many(:students).through(:memberships) }
    it { expect(group).to have_and_belong_to_many(:toasts) }
  end

  describe 'methods' do
    describe 'members methods' do
      let(:students) { [create(:user), create(:user)] }
      before { group.students = students }

      describe '#foreign_users' do
        let!(:foreign_user) { create(:user) }

        it %q|returns users that aren't members| do
          expect(group.foreign_users.reload).to contain_exactly(foreign_user)
        end
      end

      describe '#change_students' do
        context 'students' do
          context %q|when they aren't in list| do
            it 'remove students from group' do
              group.change_students([students.first])
              expect(group.students.reload).to contain_exactly(students.first)
            end
          end

          context %q|when they are in list| do
            let(:new_student) { create(:user) }

            it %q|add students to group| do
              group.change_students([*students, new_student])
              expect(group.students.reload).to contain_exactly(*students, new_student)
            end
          end

          context 'when students list is not changed' do
            it 'change nothing' do
              group.change_students(students)
              expect(group.students.reload).to contain_exactly(*students)
            end
          end
        end

        context 'owners' do
          let(:owner) { create(:teacher) }
          before { group.owners << owner }

          context 'when owner appears in list' do
            before { group.change_students([*students, owner]) }

            it 'add them to student members to' do
              expect(group.students.reload).to contain_exactly(*students, owner)
            end

            it %q|doesn't change owner status| do
              expect(group.owners.reload).to contain_exactly(owner)
            end
          end

          context 'when owner is not present in list' do
            it 'change nothing' do
              expect(group.owners.reload).to contain_exactly(owner)
              expect(group.students.reload).to contain_exactly(*students)
            end
          end
        end
      end
    end
  end
end
