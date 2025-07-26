namespace Server.Source.Interface
{
    public interface IDatabase
    {
        public IDatabase GetInstance();
        public object Open(string id);
        public void Save(object data);
        public void Delete(string id);
    }
}
