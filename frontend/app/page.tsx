export default async function Page() {
  const res = await fetch(
    `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/health`,
    {
      cache: "no-store",
    },
  );

  const data = await res.json();

  return (
    <main>
      <h1>疎通確認</h1>
      <p>{data.status}</p>
    </main>
  );
}
