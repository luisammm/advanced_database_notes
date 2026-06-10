-- ============================================================
-- CHALLENGE 11 - ORM + ALEMBIC
-- ============================================================

-- ============================================================
-- Exercise 1 - Model Design
-- ============================================================

-- Comment Model

class Comment(Base):
    __tablename__ = "comments"

    id = Column(Integer, primary_key=True)
    task_id = Column(Integer, ForeignKey("tasks.id"))
    user_id = Column(Integer, ForeignKey("users.id"))
    content = Column(String(1000), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    task = relationship("Task", back_populates="comments")
    user = relationship("User")


-- Task relationship

comments = relationship(
    "Comment",
    back_populates="task",
    cascade="all, delete-orphan"
)

-- Answers

-- What relationships should Comment have?
-- Comment should have a relationship with Task and User because
-- every comment belongs to one task and is written by one user.

-- Should Task have a comments relationship?
-- Yes. This allows easy access to all comments associated with a task.

-- What should happen when a task is deleted?
-- Its comments should also be removed to prevent orphan records.


-- ============================================================
-- Exercise 2 - Migration Creation
-- ============================================================

command.revision(
    alembic_cfg,
    autogenerate=True,
    message="add comments table"
)

-- Example migration

def upgrade():
    op.create_table(
        "comments",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("task_id", sa.Integer(), nullable=False),
        sa.Column("user_id", sa.Integer(), nullable=False),
        sa.Column("content", sa.String(1000), nullable=False),
        sa.Column("created_at", sa.DateTime())
    )

def downgrade():
    op.drop_table("comments")

-- CHECK constraint

sa.CheckConstraint(
    "TRIM(content) <> ''",
    name="ck_comment_content"
)

-- Answers

-- What does upgrade() do?
-- Applies the schema changes to the database.

-- What does downgrade() do?
-- Reverts the schema changes.

-- What happens if you downgrade?
-- The comments table is removed and any data stored inside it is lost.


-- ============================================================
-- Exercise 3 - CRUD Challenge
-- ============================================================

devops = Team(
    name="DevOps",
    description="Infrastructure and deployment"
)

session.add(devops)
session.commit()

diana = User(
    username="diana_ops",
    email="diana@example.com",
    full_name="Diana Ops",
    team=devops
)

session.add(diana)
session.commit()

task1 = Task(
    title="Configure CI",
    status="open",
    assigned_to=diana.id
)

task2 = Task(
    title="Create Monitoring",
    status="open",
    assigned_to=diana.id
)

task3 = Task(
    title="Remove Legacy Server",
    status="open",
    assigned_to=diana.id
)

session.add_all([task1, task2, task3])
session.commit()

print("Task Count:", session.query(Task).count())

task1.status = "closed"
session.commit()

session.delete(task3)
session.commit()

print("Remaining Tasks:")
for task in session.query(Task).all():
    print(task.title, task.status)


-- ============================================================
-- Exercise 4 - Migration Rollback
-- ============================================================

command.downgrade(
    alembic_cfg,
    "-1"
)

-- Answers

-- What happens to the column?
-- The estimated_hours column is removed from the schema.

-- What happens to the data?
-- Any values stored in that column are lost after the rollback.


-- ============================================================
-- Exercise 5 - Concept Check
-- ============================================================

-- Why use ORM instead of raw SQL?
-- ORM makes database interaction easier by representing tables
-- as classes and records as objects.

-- Why use migrations?
-- Migrations provide version control for database schemas and
-- allow changes to be applied consistently across environments.

-- When would you rollback?
-- When a migration introduces an error or an unintended schema change.

-- Difference between add() and commit()?
-- add() places an object in the current transaction.
-- commit() permanently saves the transaction to the database.

-- Why are relationships useful?
-- Relationships simplify navigation between related entities
-- and reduce the amount of manual query logic needed.