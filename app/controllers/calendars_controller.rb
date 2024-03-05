class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_Week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_Week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

     # 今日の曜日の数値を取得
    today_wday_num = @todays_date.wday

    # wdaysから今日の曜日の文字列を取り出す
    today_wday = wdays[today_wday_num]

    # 今日の曜日以外の曜日の情報を取得
    other_wday_index = 3 # 例えば、水曜日を取り出す場合

    other_wday = wdays[other_wday_index]

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      # wdayメソッドを用いて取得した数値
      wday_num = (@todays_date + x).wday

      # 「wday_numが7以上の場合」の条件式
      if wday_num >=7
        wday_num = wday_num - 7
      end

      # wdaysから値を取り出す記述
      wday_value = wdays[wday_num]

      days = { :month => (@todays_date + x).month, :date => (@todays_date+x).day, :plans => today_plans,  :wday => wday_value }
      @week_days.push(days)
    end

    # 今日以外の曜日の情報を取り出す
    other_wday

  end
end
