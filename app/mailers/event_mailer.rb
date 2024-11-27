class EventMailer < ApplicationMailer
  def event_created(event)
    @event = event
    mail(
      to: event.user.email,
      subject: "Tu evento '#{event.name}' ha sido creado exitosamente"
    )
  end

  # Método para enviar el correo con el reporte diario
  def daily_events_report(admin, events)
    @admin = admin
    @events = events
    mail(to: @admin.email, subject: "Daily Events Report - #{Date.today}")
  end

end