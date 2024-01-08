defmodule LiveViewSvelteOfflineDemo.Accounts.UserNotifier do
  # import Swoosh.Email

  # alias LiveViewSvelteOfflineDemo.Mailer

  # # Delivers the email using the application mailer.
  # defp deliver(recipient, subject, body) do
  #   email =
  #     new()
  #     |> to(recipient)
  #     |> from({"LiveViewSvelteOfflineDemo", "contact@example.com"})
  #     |> subject(subject)
  #     |> text_body(body)

  #   with {:ok, _metadata} <- Mailer.deliver(email) do
  #     {:ok, email}
  #   end
  # end

  alias LiveViewSvelteOfflineDemo.Jwt

  defp deliver(email, subject, html) do
    extra_claims = %{
      "app" => "ToDo",
      "email" => email,
      "name" => "",
      "subject" => "[ToDo App] #{subject}",
      "html" => """
      Hi #{email},<br><br>

      #{html}<br><br>

      --<br>
      Tony Dang<br>
      <a href="https://tonydang.blog">tonydang.blog</a><br><br>

      App Link: <a href="https://liveview-svelte-pwa.fly.dev">ToDo</a><br>
      Questions or feedback for this app? Please feel free to respond to this email!
      """
    }

    # Create JWT token.
    {:ok, token, _} = Jwt.generate_and_sign(extra_claims)

    # Send email request to JS backend.
    # TODO: Send this in the background to reduce user wait time?
    # TODO: Handle errors.
    Req.post("#{System.get_env("JS_BACKEND_URL")}/microservices/mailer/send?jwt=#{token}")
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Confirmation instructions", """
    You can confirm your account by visiting the URL below:<br><br>

    #{url}<br><br>

    If you didn't create an account, please ignore this.
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Reset password instructions", """
    You can reset your password by visiting the URL below:<br><br>

    #{url}<br><br>

    If you didn't request this change, please ignore this.
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """
    You can change your email by visiting the URL below:<br><br>

    #{url}<br><br>

    If you didn't request this change, please ignore this.
    """)
  end
end
