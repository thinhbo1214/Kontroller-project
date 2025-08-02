namespace Server.Source.Interface
{
    public interface IDatabase
    {
        public IDatabase GetInstance();
        public object Get(string id);
        public int Delete(string id);
    }
}
