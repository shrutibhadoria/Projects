import streamlit as st
import pandas as pd
import plotly.express as px

# Page configuration
st.set_page_config(page_title="🎾 Tennis Data Explorer", layout="wide")
st.title("🎾 Tennis Data Explorer")

# Load Data with cache for performance
@st.cache_data

def load_data():
    categories = pd.read_csv("categories.csv")
    competitions = pd.read_csv("competitions.csv")
    venues = pd.read_csv("venues.csv")
    complexes = pd.read_csv("complexes.csv")
    competitors = pd.read_csv("competitors.csv")
    rankings = pd.read_csv("competitor_rankings.csv")
    rankings.rename(columns={"ranks": "rank"}, inplace=True)
    return categories, competitions, venues, complexes, competitors, rankings

categories, competitions, venues, complexes, competitors, rankings = load_data()

# Merge competitors and rankings for unified view
top_competitors = rankings.merge(competitors, on="competitor_id", how="left")

# Sidebar Navigation
menu = st.sidebar.selectbox("Navigate", [
    "🏠 Dashboard", 
    "🔍 Competitor Search", 
    "📈 Country Analysis", 
    "🏅 Leaderboards", 
    "📊 Trend Analysis"])

# ----------------------------------------
# 🏠 Dashboard
# ----------------------------------------
if menu == "🏠 Dashboard":
    st.subheader("📊 Summary Statistics")

    col1, col2, col3 = st.columns(3)
    col1.metric("Total Competitors", competitors.shape[0])
    col2.metric("Countries Represented", competitors["country"].nunique())
    col3.metric("Highest Points", rankings["points"].max())

    st.subheader("🔝 Top 10 Competitors")
    top10 = top_competitors.sort_values(by="rank").head(10)
    st.dataframe(top10[["name", "rank", "points", "movement", "country"]])

# ----------------------------------------
# 🔍 Competitor Search
# ----------------------------------------
elif menu == "🔍 Competitor Search":
    st.subheader("🔎 Search & Filter Competitors")

    search_name = st.text_input("Enter Competitor Name")
    min_rank, max_rank = st.slider("Select Rank Range", 1, 1000, (1, 100))
    selected_country = st.selectbox("Select Country", ["All"] + sorted(competitors["country"].unique()))

    filtered = top_competitors[
        (top_competitors["rank"] >= min_rank) & (top_competitors["rank"] <= max_rank)
    ]

    if search_name:
        filtered = filtered[filtered["name"].str.contains(search_name, case=False)]
    if selected_country != "All":
        filtered = filtered[filtered["country"] == selected_country]

    st.dataframe(filtered[["name", "rank", "points", "movement", "country"]])

# ----------------------------------------
# 📈 Country Analysis
# ----------------------------------------
elif menu == "📈 Country Analysis":
    st.subheader("🌍 Competitors by Country")
    country_summary = top_competitors.groupby("country").agg(
        total_competitors=("competitor_id", "count"),
        avg_points=("points", "mean")
    ).reset_index().sort_values(by="total_competitors", ascending=False)

    fig = px.bar(
        country_summary.head(20), 
        x="country", y="total_competitors",
        title="Top 20 Countries by Competitors", color="avg_points",
        labels={"total_competitors": "Total Competitors", "avg_points": "Avg Points"}
    )
    st.plotly_chart(fig, use_container_width=True)
    st.dataframe(country_summary)

# ----------------------------------------
# 🏅 Leaderboards
# ----------------------------------------
elif menu == "🏅 Leaderboards":
    st.subheader("🏆 Competitor Leaderboards")

    st.write("### 🔝 Top 10 Ranked Competitors")
    top_rank = top_competitors.sort_values(by="rank").head(10)
    st.dataframe(top_rank[["name", "rank", "points", "movement", "country"]])

    st.write("### 💯 Highest Points Scored")
    top_points = top_competitors.sort_values(by="points", ascending=False).head(10)
    st.dataframe(top_points[["name", "points", "rank", "country"]])

# ----------------------------------------
# 📊 Trend Analysis (type/gender/category)
# ----------------------------------------
elif menu == "📊 Trend Analysis":
    st.subheader("📊 Competition Trends")

    tab1, tab2, tab3 = st.tabs(["By Type", "By Gender", "By Category"])

    with tab1:
     type_dist = competitions["type"].value_counts().reset_index()
     type_dist.columns = ["event_type", "count"]  # Renaming columns for clarity
     fig1 = px.pie(type_dist, names="event_type", values="count", title="Event Distribution by Type")
     st.plotly_chart(fig1)



    with tab2:
     gender_dist = competitions["gender"].value_counts().reset_index()
    gender_dist.columns = ["gender", "count"]
    fig2 = px.bar(gender_dist, x="gender", y="count", title="Event Distribution by Gender")
    st.plotly_chart(fig2)


    with tab3:
     category_dist = competitions.merge(categories, on="category_id", how="left")
    grouped = category_dist["category_name"].value_counts().head(20).reset_index()
    grouped.columns = ["category_name", "count"]
    fig3 = px.bar(grouped, x="category_name", y="count", title="Top 20 Categories by Events")
    st.plotly_chart(fig3)


# Footer
st.markdown("---")
st.markdown("Built with Streamlit| Powered by Streamlit")

