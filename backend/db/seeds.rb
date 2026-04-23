# 管理者
Admin.create!(
  name: "管理者",
  password: "password",
  password_confirmation: "password",
  effective_from: Date.current
)

# スタッフ
Staff.create!(
  name: "大阪太郎",
  password: "password",
  password_confirmation: "password",
  effective_from: Date.current,
  role: :operator
)

Staff.create!(
  name: "大阪花子",
  password: "password",
  password_confirmation: "password",
  effective_from: Date.current,
  role: :viewer
)