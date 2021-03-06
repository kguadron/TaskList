require "test_helper"

describe TasksController do
  # Note to students:  Your Task model **may** be different and
  #   you may need to modify this.
  let (:task) {
    Task.create name: "sample task", description: "this is an example for a test",
                due_date: "today"
  }

  # Tests for Wave 1
  describe "index" do
    it "can get the index path" do
      # Act
      get tasks_path

      # Assert
      must_respond_with :success
    end

    it "can get the root path" do
      # Act
      get root_path

      # Assert
      must_respond_with :success
    end
  end

  # Unskip these tests for Wave 2
  describe "show" do
    it "can get a valid task" do
      # Act
      get task_path(task.id)

      # Assert
      must_respond_with :success
    end

    it "will redirect for an invalid task" do
      # Act
      get task_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "new" do
    it "can get the new task page" do
      # Act
      get new_task_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new task" do
      # Arrange
      task_hash = {
        task: {
          name: "new task",
          description: "new task description",
          due_date: "Monday",
        },
      }

      # Act-Assert
      expect {
        post tasks_path, params: task_hash
      }.must_change "Task.count", 1

      new_task = Task.find_by(name: task_hash[:task][:name])

      expect(new_task.description).must_equal task_hash[:task][:description]
      expect(new_task.due_date).must_equal task_hash[:task][:due_date]

      must_respond_with :redirect
      must_redirect_to task_path(new_task.id)
    end
  end

  # Unskip and complete these tests for Wave 3
  describe "edit" do
    it "can get the edit page for an existing task" do
      # Act
      get edit_task_path(id: task.id)

      # Assert
      must_respond_with :success
    end

    it "will respond with redirect when attempting to edit a nonexistant task" do
      #Act
      get edit_task_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  # Uncomment and complete these tests for Wave 3
  describe "update" do
    # Note:  If there was a way to fail to save the changes to a task, that would be a great
    #        thing to test.
    it "can update an existing task" do
      #Arrange
      task_hash = {
        task: {
          name: "edited task",
          description: "edited task description",
          due_date: "Tuesday",
        },
      }
   
      patch task_path(id: task.id), params: task_hash

      edited_task = Task.find_by(name: task_hash[:task][:name])
      expect(edited_task.name).must_equal task_hash[:task][:name]
      expect(edited_task.description).must_equal task_hash[:task][:description]
      expect(edited_task.due_date).must_equal task_hash[:task][:due_date]
    end

    it "will redirect to the root page if given an invalid id" do
      #Act
      get edit_task_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  # Complete these tests for Wave 4
  describe "destroy" do
    it "removes the task from the database" do
      # Arrange
      task = Task.create!(name: "test_task")

      # Act
      expect {
        delete task_path(task)
      }.must_change "Task.count", -1

      # Assert
      must_respond_with :redirect
      must_redirect_to tasks_path

      after_task = Task.find_by(id: task.id)
      expect(after_task).must_be_nil
    end

    it "returns a 404 if the task does not exist" do
      # Arrange
      task_id = 123456

      # Assumptions
      expect(Task.find_by(id: task_id)).must_be_nil

      # Act
      expect {
        delete task_path(task_id)
      }.wont_change "Task.count"

      # Assert
      must_respond_with :not_found
    end

    # Complete for Wave 4
    describe "complete" do
      it "changes completed status of a task" do
        post complete_task_path(id: task.id)

        completed_task = Task.find_by(completed: true)
        expect(completed_task.completed).must_equal true
      end

      it "sets todays date as completion date if completion status is true" do
        post complete_task_path(id: task.id)

        completed_task = Task.find_by(completed: true)
        expect(completed_task.date_completed).must_equal Date.today
      end

      it "will redirect to the root page" do
        post complete_task_path(id: task.id)

        must_respond_with :redirect
      end
    end
  end
end

